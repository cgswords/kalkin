# Author:      Chris Wailes <chris.wailes@gmail.com>
# Project:     Kalkin
# Date:        2014/03/25
# Description: This is the base file for Kalkin's LLVM backend.

module Kalkin; module Backends; module LLVM
	def populate_namespace(ns)
		ns.add_members(NodeList.new([
				Kalkin::AST::Klass.new('Integer'),
				Kalkin::AST::Klass.new('Float')
			])
	end
end; end; end
