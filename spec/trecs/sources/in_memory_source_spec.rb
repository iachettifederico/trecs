require "spec_helper"
require "sources/in_memory_source"

module TRecs
  describe InMemorySource do
    Given(:source) { InMemorySource.new(trecs_backend: trecs_backend) }
    context "creating from scratch" do
      Given(:trecs_backend) { Hash.new }

      When { source.create_recording }

      context "creation" do
        Then { trecs_backend.keys.any? }
      end

      context "creating a manifest" do
        When { source[:format] = "FORMAT" }

        Then { source[:format] == "FORMAT" }
        Then { trecs_backend[:manifest][:format] == "FORMAT" }
      end

      context "adding entries" do
        context "root level" do
          When {
            source.add_entry("an_entry") do |e|
              e.write "THE CONTENT"
            end
          }

          Then { trecs_backend["an_entry"] == "THE CONTENT" }
        end

        context "one level deep" do
          When {
            source.add_entry("a_section/an_entry") do |e|
              e.write "THE CONTENT"
            end
          }

          Then { trecs_backend["a_section"]["an_entry"] == "THE CONTENT" }
        end

        context "two entries one level deep" do
          When {
            source.add_entry("a_section/an_entry") do |e|
              e.write "THE CONTENT"
            end

            source.add_entry("a_section/another_entry") do |e|
              e.write "THE OTHER CONTENT"
            end
          }

          Then { trecs_backend["a_section"]["an_entry"]      == "THE CONTENT" }
          Then { trecs_backend["a_section"]["another_entry"] == "THE OTHER CONTENT" }
        end
      end

    end

    context "reading a recording" do
      Given(:trecs_backend) {
        { "a" => { "b" => { "c.txt" => "ABC" } } }
      }
      Then { source.read_entry("a/b/c.txt")     == "ABC" }

      Then { source.read_entry("a/b/c.t")       == nil   }
      Then { source.read_entry("a/d/f/g/i.txt") == nil   }
      
      Then { source.read_entry("a/d/f/g/i.txt") == nil   }
    end

    context "handling non-empty recordings" do
      context "#clear" do
        Given(:trecs_backend) {
          { "a" => { "b" => { "c.txt" => "ABC" } } }
        }

        When {
          source.create_recording
          source.clear
        }

        Then { trecs_backend == {} }
      end

    end
  end
end
