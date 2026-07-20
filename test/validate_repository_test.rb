require "minitest/autorun"
require "yaml"
require "pathname"

ROOT = Pathname.new(File.expand_path("..", __dir__))
AGENTS_DIR = ROOT.join(".github/agents")

class ValidateRepositoryTest < Minitest::Test
  def agent_files
    Dir.glob(AGENTS_DIR.join("*.agent.md")).sort
  end

  def frontmatter(path)
    content = File.read(path)
    assert content.start_with?("---\n"), "#{path} must start with a YAML frontmatter block"

    _, raw_frontmatter, body = content.split(/^---\s*$/, 3)
    assert raw_frontmatter, "#{path} has no closing --- for its frontmatter"

    [YAML.safe_load(raw_frontmatter), body]
  end

  def test_every_agent_file_has_parseable_frontmatter_with_description_and_tools
    refute_empty agent_files, "expected at least one .agent.md file in #{AGENTS_DIR}"

    agent_files.each do |path|
      data, = frontmatter(path)
      assert_kind_of Hash, data, "#{path} frontmatter did not parse into a YAML mapping"
      assert data.key?("description"), "#{path} frontmatter is missing 'description'"
      assert data.key?("tools"), "#{path} frontmatter is missing 'tools'"
      refute_empty data["description"].to_s.strip, "#{path} has an empty description"
    end
  end

  def test_ask_and_plan_do_not_declare_write_tools
    write_tools = %w[edit runCommands runTests]

    %w[ask plan].each do |mode|
      path = AGENTS_DIR.join("#{mode}.agent.md")
      assert File.exist?(path), "expected #{path} to exist"

      data, = frontmatter(path)
      declared = Array(data["tools"])
      overlap = declared & write_tools

      assert_empty overlap,
        "#{path} is supposed to be read-only but declares write tool(s): #{overlap.join(', ')}"
    end
  end

  def test_agent_mode_declares_edit_tool
    path = AGENTS_DIR.join("agent.agent.md")
    data, = frontmatter(path)

    assert_includes Array(data["tools"]), "edit",
      "#{path} is the implementation mode and should declare the 'edit' tool"
  end

  def test_readme_relative_links_point_to_existing_files
    readme = ROOT.join("README.md")
    content = File.read(readme)

    content.scan(/\]\(([^)]+)\)/).flatten.each do |link|
      next if link.start_with?("http://", "https://", "#")

      target = ROOT.join(link.split("#").first)
      assert target.exist?, "README.md links to '#{link}', which does not exist"
    end
  end

  def test_agent_files_do_not_duplicate_shared_stack_or_persona_content
    markers = ["Stacks principais:", "calmo, confiante e levemente espirituoso"]

    agent_files.each do |path|
      _, body = frontmatter(path)

      markers.each do |marker|
        refute_includes body, marker,
          "#{path} embeds shared content ('#{marker}') instead of referencing .github/instructions/"
      end
    end
  end

  def test_plan_handoff_points_to_an_existing_agent_name
    data, = frontmatter(AGENTS_DIR.join("plan.agent.md"))
    handoffs = Array(data["handoffs"])
    refute_empty handoffs, "plan.agent.md should declare a handoff to the Agent mode"

    known_names = agent_files.map { |path| frontmatter(path).first["name"] }

    handoffs.each do |handoff|
      assert_includes known_names, handoff["agent"],
        "plan.agent.md handoff targets '#{handoff['agent']}', which doesn't match any agent's 'name:'"
    end
  end

  def test_prompts_directory_no_longer_exists
    refute ROOT.join("prompts").exist?,
      "prompts/ was removed in favor of .github/agents/ as the single source; it should not come back"
  end
end
