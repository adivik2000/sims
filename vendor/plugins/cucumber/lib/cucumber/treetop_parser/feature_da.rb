module Cucumber
module TreetopParser

module Feature
  include Treetop::Runtime

  def root
    @root || :root
  end

  module Root0
    def header
      elements[0]
    end

    def scenario_sequence
      elements[1]
    end

  end

  module Root1
    def compile
      feature = Tree::Feature.new(header.text_value.strip)
      scenario_sequence.compile(feature)
      feature
    end
  end

  def _nt_root
    start_index = index
    if node_cache[:root].has_key?(index)
      cached = node_cache[:root][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_header
    s0 << r1
    if r1
      r2 = _nt_scenario_sequence
      s0 << r2
      if r2
        r4 = _nt_space
        if r4
          r3 = r4
        else
          r3 = SyntaxNode.new(input, index...index)
        end
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Root0)
      r0.extend(Root1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:root][start_index] = r0

    return r0
  end

  module Header0
  end

  def _nt_header
    start_index = index
    if node_cache[:header].has_key?(index)
      cached = node_cache[:header][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      r3 = _nt_scenario_keyword
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s1 << r2
      if r2
        if index < input_length
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("any character")
          r4 = nil
        end
        s1 << r4
      end
      if s1.last
        r1 = (SyntaxNode).new(input, i1...index, s1)
        r1.extend(Header0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
    end

    node_cache[:header][start_index] = r0

    return r0
  end

  module ScenarioSequence0
    def space
      elements[0]
    end

    def scenario_or_table
      elements[1]
    end
  end

  module ScenarioSequence1
    def head
      elements[0]
    end

    def tail
      elements[1]
    end
  end

  module ScenarioSequence2
    def compile(feature)
      ([head] + tail).each do |scenario_or_table|
        scenario_or_table.compile(feature) if scenario_or_table.respond_to?(:compile)
      end
    end
    
    def tail
      super.elements.map { |elt| elt.scenario_or_table }
    end
  end

  def _nt_scenario_sequence
    start_index = index
    if node_cache[:scenario_sequence].has_key?(index)
      cached = node_cache[:scenario_sequence][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r2 = _nt_scenario
    if r2
      r1 = r2
    else
      r1 = SyntaxNode.new(input, index...index)
    end
    s0 << r1
    if r1
      s3, i3 = [], index
      loop do
        i4, s4 = index, []
        r5 = _nt_space
        s4 << r5
        if r5
          r6 = _nt_scenario_or_table
          s4 << r6
        end
        if s4.last
          r4 = (SyntaxNode).new(input, i4...index, s4)
          r4.extend(ScenarioSequence0)
        else
          self.index = i4
          r4 = nil
        end
        if r4
          s3 << r4
        else
          break
        end
      end
      r3 = SyntaxNode.new(input, i3...index, s3)
      s0 << r3
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(ScenarioSequence1)
      r0.extend(ScenarioSequence2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:scenario_sequence][start_index] = r0

    return r0
  end

  module Scenario0
    def space
      elements[0]
    end

    def step_sequence
      elements[1]
    end
  end

  module Scenario1
    def scenario_keyword
      elements[0]
    end

    def space
      elements[1]
    end

    def name
      elements[2]
    end

    def steps
      elements[3]
    end
  end

  module Scenario2
    def compile(feature)
      scenario = feature.add_scenario(name.text_value.strip)
      steps.step_sequence.compile(scenario) if steps.respond_to?(:step_sequence)
      # TODO - GET RID OF THIS last_scenario NASTINESS
      # Use a better datastructure, like a linked list...
      Feature.last_scenario = scenario
    end
  end

  def _nt_scenario
    start_index = index
    if node_cache[:scenario].has_key?(index)
      cached = node_cache[:scenario][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_scenario_keyword
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_line_to_eol
        s0 << r3
        if r3
          i5, s5 = index, []
          r6 = _nt_space
          s5 << r6
          if r6
            r7 = _nt_step_sequence
            s5 << r7
          end
          if s5.last
            r5 = (SyntaxNode).new(input, i5...index, s5)
            r5.extend(Scenario0)
          else
            self.index = i5
            r5 = nil
          end
          if r5
            r4 = r5
          else
            r4 = SyntaxNode.new(input, index...index)
          end
          s0 << r4
        end
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Scenario1)
      r0.extend(Scenario2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:scenario][start_index] = r0

    return r0
  end

  def _nt_scenario_or_table
    start_index = index
    if node_cache[:scenario_or_table].has_key?(index)
      cached = node_cache[:scenario_or_table][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_scenario
    if r1
      r0 = r1
    else
      r2 = _nt_table
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:scenario_or_table][start_index] = r0

    return r0
  end

  module Table0
    def eol
      elements[1]
    end

    def table_line
      elements[3]
    end
  end

  module Table1
    def head
      elements[0]
    end

    def body
      elements[1]
    end
  end

  module Table2
    def compile(feature)
      Feature.last_scenario.table_header = head.cell_values
      body.each do |table_line|
        feature.add_row_scenario(Feature.last_scenario, table_line.cell_values, table_line.line)
      end
    end

    def body
      super.elements.map { |elt| elt.table_line }
    end
  end

  def _nt_table
    start_index = index
    if node_cache[:table].has_key?(index)
      cached = node_cache[:table][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_table_line
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        s4, i4 = [], index
        loop do
          r5 = _nt_blank
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s3 << r4
        if r4
          r6 = _nt_eol
          s3 << r6
          if r6
            r8 = _nt_space
            if r8
              r7 = r8
            else
              r7 = SyntaxNode.new(input, index...index)
            end
            s3 << r7
            if r7
              r9 = _nt_table_line
              s3 << r9
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(Table0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(Table1)
      r0.extend(Table2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:table][start_index] = r0

    return r0
  end

  module TableLine0
    def cell_value
      elements[1]
    end

    def separator
      elements[3]
    end
  end

  module TableLine1
    def separator
      elements[0]
    end

    def cells
      elements[1]
    end
  end

  module TableLine2
    def cell_values
      cells.elements.map { |elt| elt.cell_value.text_value.strip }
    end

    def line
      input.line_of(interval.first)
    end
  end

  def _nt_table_line
    start_index = index
    if node_cache[:table_line].has_key?(index)
      cached = node_cache[:table_line][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_separator
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        s4, i4 = [], index
        loop do
          r5 = _nt_blank
          if r5
            s4 << r5
          else
            break
          end
        end
        r4 = SyntaxNode.new(input, i4...index, s4)
        s3 << r4
        if r4
          r6 = _nt_cell_value
          s3 << r6
          if r6
            s7, i7 = [], index
            loop do
              r8 = _nt_blank
              if r8
                s7 << r8
              else
                break
              end
            end
            r7 = SyntaxNode.new(input, i7...index, s7)
            s3 << r7
            if r7
              r9 = _nt_separator
              s3 << r9
            end
          end
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(TableLine0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      if s2.empty?
        self.index = i2
        r2 = nil
      else
        r2 = SyntaxNode.new(input, i2...index, s2)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(TableLine1)
      r0.extend(TableLine2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:table_line][start_index] = r0

    return r0
  end

  module CellValue0
  end

  def _nt_cell_value
    start_index = index
    if node_cache[:cell_value].has_key?(index)
      cached = node_cache[:cell_value][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      i3 = index
      r4 = _nt_separator
      if r4
        r3 = r4
      else
        r5 = _nt_eol
        if r5
          r3 = r5
        else
          self.index = i3
          r3 = nil
        end
      end
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s1 << r2
      if r2
        if index < input_length
          r6 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("any character")
          r6 = nil
        end
        s1 << r6
      end
      if s1.last
        r1 = (SyntaxNode).new(input, i1...index, s1)
        r1.extend(CellValue0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:cell_value][start_index] = r0

    return r0
  end

  module StepSequence0
    def space
      elements[0]
    end

    def step
      elements[1]
    end
  end

  module StepSequence1
    def head
      elements[0]
    end

    def tail
      elements[1]
    end
  end

  module StepSequence2
    def compile(scenario)
      ([head] + tail).each do |step|
        step.compile(scenario)
      end
    end
    
    def tail
      super.elements.map { |elt| elt.step }
    end
  end

  def _nt_step_sequence
    start_index = index
    if node_cache[:step_sequence].has_key?(index)
      cached = node_cache[:step_sequence][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_step
    s0 << r1
    if r1
      s2, i2 = [], index
      loop do
        i3, s3 = index, []
        r4 = _nt_space
        s3 << r4
        if r4
          r5 = _nt_step
          s3 << r5
        end
        if s3.last
          r3 = (SyntaxNode).new(input, i3...index, s3)
          r3.extend(StepSequence0)
        else
          self.index = i3
          r3 = nil
        end
        if r3
          s2 << r3
        else
          break
        end
      end
      r2 = SyntaxNode.new(input, i2...index, s2)
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(StepSequence1)
      r0.extend(StepSequence2)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:step_sequence][start_index] = r0

    return r0
  end

  def _nt_step
    start_index = index
    if node_cache[:step].has_key?(index)
      cached = node_cache[:step][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_given_scenario
    if r1
      r0 = r1
    else
      r2 = _nt_plain_step
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:step][start_index] = r0

    return r0
  end

  module GivenScenario0
    def given_scenario_keyword
      elements[0]
    end

    def space
      elements[1]
    end

    def name
      elements[2]
    end
  end

  module GivenScenario1
    def compile(scenario)
      line = input.line_of(interval.first)
      scenario.add_given_scenario(name.text_value.strip, line)
    end
  end

  def _nt_given_scenario
    start_index = index
    if node_cache[:given_scenario].has_key?(index)
      cached = node_cache[:given_scenario][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_given_scenario_keyword
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_line_to_eol
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(GivenScenario0)
      r0.extend(GivenScenario1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:given_scenario][start_index] = r0

    return r0
  end

  module PlainStep0
    def step_keyword
      elements[0]
    end

    def space
      elements[1]
    end

    def name
      elements[2]
    end
  end

  module PlainStep1
    def compile(scenario)
      line = input.line_of(interval.first)
      scenario.add_step(step_keyword.text_value, name.text_value.strip, line)
    end
  end

  def _nt_plain_step
    start_index = index
    if node_cache[:plain_step].has_key?(index)
      cached = node_cache[:plain_step][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    r1 = _nt_step_keyword
    s0 << r1
    if r1
      r2 = _nt_space
      s0 << r2
      if r2
        r3 = _nt_line_to_eol
        s0 << r3
      end
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(PlainStep0)
      r0.extend(PlainStep1)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:plain_step][start_index] = r0

    return r0
  end

  def _nt_separator
    start_index = index
    if node_cache[:separator].has_key?(index)
      cached = node_cache[:separator][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('|', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('|')
      r0 = nil
    end

    node_cache[:separator][start_index] = r0

    return r0
  end

  def _nt_space
    start_index = index
    if node_cache[:space].has_key?(index)
      cached = node_cache[:space][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1 = index
      r2 = _nt_white
      if r2
        r1 = r2
      else
        r3 = _nt_comment_to_eol
        if r3
          r1 = r3
        else
          self.index = i1
          r1 = nil
        end
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    if s0.empty?
      self.index = i0
      r0 = nil
    else
      r0 = SyntaxNode.new(input, i0...index, s0)
    end

    node_cache[:space][start_index] = r0

    return r0
  end

  module LineToEol0
  end

  def _nt_line_to_eol
    start_index = index
    if node_cache[:line_to_eol].has_key?(index)
      cached = node_cache[:line_to_eol][index]
      @index = cached.interval.end if cached
      return cached
    end

    s0, i0 = [], index
    loop do
      i1, s1 = index, []
      i2 = index
      r3 = _nt_eol
      if r3
        r2 = nil
      else
        self.index = i2
        r2 = SyntaxNode.new(input, index...index)
      end
      s1 << r2
      if r2
        if index < input_length
          r4 = (SyntaxNode).new(input, index...(index + 1))
          @index += 1
        else
          terminal_parse_failure("any character")
          r4 = nil
        end
        s1 << r4
      end
      if s1.last
        r1 = (SyntaxNode).new(input, i1...index, s1)
        r1.extend(LineToEol0)
      else
        self.index = i1
        r1 = nil
      end
      if r1
        s0 << r1
      else
        break
      end
    end
    r0 = SyntaxNode.new(input, i0...index, s0)

    node_cache[:line_to_eol][start_index] = r0

    return r0
  end

  module CommentToEol0
    def line_to_eol
      elements[1]
    end
  end

  def _nt_comment_to_eol
    start_index = index
    if node_cache[:comment_to_eol].has_key?(index)
      cached = node_cache[:comment_to_eol][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('#', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      terminal_parse_failure('#')
      r1 = nil
    end
    s0 << r1
    if r1
      r2 = _nt_line_to_eol
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(CommentToEol0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:comment_to_eol][start_index] = r0

    return r0
  end

  def _nt_white
    start_index = index
    if node_cache[:white].has_key?(index)
      cached = node_cache[:white][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    r1 = _nt_blank
    if r1
      r0 = r1
    else
      r2 = _nt_eol
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:white][start_index] = r0

    return r0
  end

  def _nt_blank
    start_index = index
    if node_cache[:blank].has_key?(index)
      cached = node_cache[:blank][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index(Regexp.new('[ \\t]'), index) == index
      r0 = (SyntaxNode).new(input, index...(index + 1))
      @index += 1
    else
      r0 = nil
    end

    node_cache[:blank][start_index] = r0

    return r0
  end

  def _nt_eol
    start_index = index
    if node_cache[:eol].has_key?(index)
      cached = node_cache[:eol][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index("\r\n?", index) == index
      r1 = (SyntaxNode).new(input, index...(index + 3))
      @index += 3
    else
      terminal_parse_failure("\r\n?")
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index("\n", index) == index
        r2 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure("\n")
        r2 = nil
      end
      if r2
        r0 = r2
      else
        self.index = i0
        r0 = nil
      end
    end

    node_cache[:eol][start_index] = r0

    return r0
  end

  def _nt_step_keyword
    start_index = index
    if node_cache[:step_keyword].has_key?(index)
      cached = node_cache[:step_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0 = index
    if input.index('Givet', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 5))
      @index += 5
    else
      terminal_parse_failure('Givet')
      r1 = nil
    end
    if r1
      r0 = r1
    else
      if input.index('Når', index) == index
        r2 = (SyntaxNode).new(input, index...(index + 4))
        @index += 4
      else
        terminal_parse_failure('Når')
        r2 = nil
      end
      if r2
        r0 = r2
      else
        if input.index('Så', index) == index
          r3 = (SyntaxNode).new(input, index...(index + 3))
          @index += 3
        else
          terminal_parse_failure('Så')
          r3 = nil
        end
        if r3
          r0 = r3
        else
          if input.index('Og', index) == index
            r4 = (SyntaxNode).new(input, index...(index + 2))
            @index += 2
          else
            terminal_parse_failure('Og')
            r4 = nil
          end
          if r4
            r0 = r4
          else
            self.index = i0
            r0 = nil
          end
        end
      end
    end

    node_cache[:step_keyword][start_index] = r0

    return r0
  end

  def _nt_scenario_keyword
    start_index = index
    if node_cache[:scenario_keyword].has_key?(index)
      cached = node_cache[:scenario_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    if input.index('Scenarie:', index) == index
      r0 = (SyntaxNode).new(input, index...(index + 9))
      @index += 9
    else
      terminal_parse_failure('Scenarie:')
      r0 = nil
    end

    node_cache[:scenario_keyword][start_index] = r0

    return r0
  end

  module GivenScenarioKeyword0
  end

  def _nt_given_scenario_keyword
    start_index = index
    if node_cache[:given_scenario_keyword].has_key?(index)
      cached = node_cache[:given_scenario_keyword][index]
      @index = cached.interval.end if cached
      return cached
    end

    i0, s0 = index, []
    if input.index('GivetScenarie', index) == index
      r1 = (SyntaxNode).new(input, index...(index + 13))
      @index += 13
    else
      terminal_parse_failure('GivetScenarie')
      r1 = nil
    end
    s0 << r1
    if r1
      if input.index(':', index) == index
        r3 = (SyntaxNode).new(input, index...(index + 1))
        @index += 1
      else
        terminal_parse_failure(':')
        r3 = nil
      end
      if r3
        r2 = r3
      else
        r2 = SyntaxNode.new(input, index...index)
      end
      s0 << r2
    end
    if s0.last
      r0 = (SyntaxNode).new(input, i0...index, s0)
      r0.extend(GivenScenarioKeyword0)
    else
      self.index = i0
      r0 = nil
    end

    node_cache[:given_scenario_keyword][start_index] = r0

    return r0
  end

end

class FeatureParser < Treetop::Runtime::CompiledParser
  include Feature
end


end
end