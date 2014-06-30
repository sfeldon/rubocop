# encoding: utf-8

module RuboCop
  module Cop
    module Style
      # Access modifiers should be surrounded by blank lines.
      class EmptyLinesAroundAccessModifier < Cop
        include AccessModifierNode

        MSG = 'Keep a blank line before and after `%s`.'

        def on_send(node)
          return unless modifier_node?(node)

          return if empty_lines_around?(node)

          add_offense(node, :expression)
        end

        private

        def empty_lines_around?(node)
          send_line = node.loc.line
          previous_line = processed_source[send_line - 2]
          next_line = processed_source[send_line]

          (class_def?(previous_line.lstrip) ||
           previous_line.blank?) &&
            next_line.blank?
        end

        def class_def?(line)
          %w(class module).any? { |keyword| line.start_with?(keyword) }
        end

        def message(node)
          format(MSG, node.loc.selector.source)
        end
      end
    end
  end
end
