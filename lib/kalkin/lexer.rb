# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Kalkin
# Date:		2014/03/26
# Description:	This file contains the lexer definition for Kalkin.

############
# Requires #
############

# RTLK
require 'rltk/lexer'

#######################
# Classes and Modules #
#######################

module Kalkin
	class Lexer < RLTK::Lexer

		##################
		# Character Sets #
		##################

		OP_CHARACTERS = '[~!%^&*+=?<>|\/-]'

		############
		# Keywords #
		############

		rule(/class/)     { :CLASS         }
		rule(/def/)       { :DEF           }
		rule(/do/)        { :DO            }
		rule(/else/)      { :ELSE          }
		rule(/end/)       { :END           }
		rule(/false/)     { [:BOOL, false] }
		rule(/if/)        { :IF            }
		rule(/lambda/)    { :LAMBDA        }
		rule(/let/)       { :LET           }
		rule(/match/)     { :WITH          }
		rule(/namespace/) { :NAMESPACE     }
		rule(/return/)    { :RETURN        }
		rule(/self/)      { :SELF          }
		rule(/then/)      { :THEN          }
		rule(/true/)      { [:BOOL, true]  }
		rule(/void/)      { :VOID          }
		rule(/when/)      { :WHEN          }
		rule(/with/)      { :WITH          }

		###########################
		# Punctuation and Symbols #
		###########################

		rule(/->/) { :ARROW      }
		rule(/:/)  { :COLON      }
		rule(/,/)  { :COMMA      }
		rule(/\./) { :DOT        }
		rule(/{/)  { :LBRACE     }
		rule(/\[/) { :LBRACKET   }
		rule(/\(/) { :LPAREN     }
		rule(/\n/) { :NEWLINE    }
		rule(/}/)  { :RBRACE     }
		rule(/\]/) { :RBRACKET   }
		rule(/\)/) { :RPAREN     }
		rule(/;/)  { :SEMICOLON  }
		rule(/\$/) { :SIGIL      }
		rule(/_/)  { :UNDERSCORE }

		rule(/#{OP_CHARACTERS}+/) { |t| [:OPERATOR, t] }

		###############
		# Annotations #
		###############

		rule(/@[a-z_]/)  { |t| [:ANNOTATION, [t[1..-1],  :inform]] }
		rule(/@![a-z_]/) { |t| [:ANNOTATION, [t[1..-1],  :insist]] }
		rule(/@?[a-z_]/) { |t| [:ANNOTATION, [t[1..-1], :inquire]] }
		rule(/@‽[a-z_]/) { |t| [:ANNOTATION, [t[1..-1],    :warn]] }

		############
		# Literals #
		############

		rule(/:[a-z_]+/)                  { |t| [:ATOM,    t[1..-1]] }
		rule(/[+-]?\d+\.\d+/)             { |t| [:FLOAT,     t.to_f] }
		rule(/[+-]?\d+/)                  { |t| [:INTEGER,   t.to_i] }
		rule(/['"](\\'\\"|[^'"\n])*['"]/) { |t| [:STRING,         t] }

		###############
		# Identifiers #
		###############

		rule(/[A-Z][A-Za-z]*/)                    { |t| [:NSIDENT, t] }
		rule(/[a-z](\w|#{OP_CHARACTERS})*/)       { |t| [:IDENT,   t] }

		##############
		# Whitespace #
		##############

		rule(/[ \t]+/)

		############
		# Comments #
		############

		rule(/#/)                    { push_state :line_comment }
		rule(/\n/,    :line_comment) { pop_state }
		rule(/[^\n]/, :line_comment)

		rule(/#\*/)                  { push_state :block_comment }
		rule(/#\*/, :block_comment)  { push_state :block_comment }
		rule(/\*#/, :block_comment)  { pop_state                 }
		rule(/./,   :block_comment)
	end
end
