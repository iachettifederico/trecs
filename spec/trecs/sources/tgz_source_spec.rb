# require "spec_helper"
# require "sources/tgz_source"
# require "stringio"
# require 'archive/tar/minitar'
# 
# require "spec_helper"
# require "sources/in_memory_source"
# 
# module TRecs
#   describe TgzSource do
#     Given(:source) { TgzSource.new(trecs_backend: trecs_backend) }
#     context "creating from scratch" do
#       Given(:trecs_backend) { StringIO.new }
# 
#       When { source.create_recording }
# 
#       context "creation" do
#         When { trecs_backend.rewind }
#         Then { !trecs_backend.string.empty? }
#       end
# 
#       context "creating a manifest" do
#         When { source[:format] = "FORMAT" }
# 
#         Then { source[:format] == "FORMAT" }
#       end
# 
#       context "adding entries" do
#         context "root level" do
#           When {
#             source.add_entry("an_entry") do |e|
#               e.write "THE CONTENT"
#             end
#           }
# 
#           Then { trecs_backend["an_entry"] == "THE CONTENT" }
#         end
#         #
#         #        context "one level deep" do
#         #          When {
#         #            source.add_entry("a_section/an_entry") do |e|
#         #              e.write "THE CONTENT"
#         #            end
#         #          }
#         #
#         #          Then { trecs_backend["a_section"]["an_entry"] == "THE CONTENT" }
#         #        end
#         #
#         #        context "two entries one level deep" do
#         #          When {
#         #            source.add_entry("a_section/an_entry") do |e|
#         #              e.write "THE CONTENT"
#         #            end
#         #
#         #            source.add_entry("a_section/another_entry") do |e|
#         #              e.write "THE OTHER CONTENT"
#         #            end
#         #          }
#         #
#         #          Then { trecs_backend["a_section"]["an_entry"]      == "THE CONTENT" }
#         #          Then { trecs_backend["a_section"]["another_entry"] == "THE OTHER CONTENT" }
#         #        end
#       end
#     end
#     #
#     #    context "reading a recording" do
#     #      Given(:trecs_backend) { StringIO.new }
#     #
#     #      When {
#     #        source.add_entry("a/b/c.txt") do |e|
#     #          e.write "ABC"
#     #        end
#     #      }
#     #
#     #      Then { source.read_entry("a/b/c.txt")     == "ABC" }
#     #
#     #      Then { source.read_entry("a/b/c.t")       == nil   }
#     #      Then { source.read_entry("a/d/f/g/i.txt") == nil   }
#     #    end
#     #
#     #    context "handling non-empty recordings" do
#     #      context "#clear" do
#     #        Given(:trecs_backend) {
#     #          { "a" => { "b" => { "c.txt" => "ABC" } } }
#     #        }
#     #
#     #        When {
#     #          source.create_recording
#     #          source.clear
#     #        }
#     #
#     #        Then { trecs_backend == {} }
#     #      end
#     #
#     #    end
#   end
# end
# 
# 
# # module TRecs
# #   describe TgzSource do
# #     Given(:trecs_backend) { StringIO.new }
# #     Given(:source) { TgzSource.new(trecs_backend: trecs_backend) }
# 
# 
# #     context "creation" do
# #       When { source.create_recording }
# #       Then { !trecs_backend.to_s.empty? }
# #     end
# 
# #     context "manifest" do
# #       When { source.create_recording }
# #       When { source["format"] = "THE FORMAT" }
# 
# #       Then { trecs_backend.read == "" }
# #       Then { source.manifest == { "format" => "THE FORMAT"} }
# #     end
# #   end
# # end
