# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/11/09
# Description: This file contains a pretty-printer for the Kalkin AST.

############
# Requires #
############

require 'pp'

# Filigree
require 'filigree/visitor'

# Project
require 'kalkin/ast'

#######################
# Classes and Modules #
#######################

module Kalkin

	class ASTWriter
		include Kalkin::AST

		include Filigree::Visitor

		strict_match true

		def initialize
			@indent    = 0
			@col_limit = 80
		end

		# Helper functions

		def indent
			@indent += 1

			newline
		end

		def newline
			"\n" + ("\t" * @indent)
		end

		def undent
			@indent -= 1

			newline
		end

		# Patterns

		on Function.(n, params, b, ty) do
			"def #{n}(#{visit params}) : #{ty}#{indent}#{visit b}#{undent}end"
		end

		on FunctionCall.(n, a, _) do
			"#{n}(#{visit a})"
		end

		on MessageSend.(n, s, a, _) do |node|
			if s.is_a?(MessageSend) and s.operator?
				"(#{visit s})"
			else
				visit s
			end +

			if node.operator?
				" #{n} #{visit a}"
			else
				".#{n}" + (a.empty? ? '' : "(#{visit a})")
			end
		end

		on UnaryMessageSend.(n, s, _) do
			"#{n}#{visit s}"
		end

		on SplitMessageSend.(m, o, s, a, _) do
			"#{visit s}.#{m} #{o} #{visit a}"
		end

		on If.(c, t, e, ty) do
			"if #{visit c} then #{visit t} else #{visit e} end"
		end

		on Literal.(v, _) do
			v.to_s
		end

		on KAtom.(a, _) do
			':' + a.to_s
		end

		on UnresolvedSymbol.(i, _) do
			i
		end

		on RefBind.(n, t) do |b|
			b.elide_type? ? n : "#{n} : #{t}"
		end

		on RefUse.(b, _) do
			b.name
		end

		on Klass.(~:name) do
			"class #{name}\nend"
		end

		on Namespace.(_, array) do
			array.map { |n| visit n }.join("\n" + newline)
		end

		on ArgList.(array) do
			array.map { |n| visit n }.join(', ')
		end

		on NodeList.(array) do
			array.map { |d| visit d }.join("\n" + newline)
		end

		on ExprSequence.(array, t) do |node|
			array.map { |e| visit e }.join(newline)
		end

		on ParamList.(array) do
			array.map { |p| visit p }.join(', ')
		end

#		on Object do |obj|
#			pp obj
#			pp obj.destructure(42)

#			:bar
#		end
	end
end
