require "pry-session/version"
require 'pry'

# Makes for some cleaner code
require 'pipeable'
class Object; include Pipeable end

module PrySession
  SESSION_DIR = "#{Dir.home}/.pry-sessions"

  class FileMeta
    attr_accessor :name, :path, :size, :ctime

    def initialize(args={})
      @name  = args[:name]
      @path  = args[:path]
      @size  = args[:size]
      @ctime = args[:ctime]
    end

    def to_s
      "%-15s %10s bytes %-25s" % [name, size, ctime]
    end
  end

  Commands = Pry::CommandSet.new do
    # Have to force a session refresh on this, talk to core team later.
    # create_command 'new-session', 'Starts a new session' do
    #   banner <<-BANNER
    #     Usage: new-session

    #     Starts a new session.
    #   BANNER

    #   def process
    #     Pry.history.session_line_count = 0
    #   end
    # end

    create_command 'save-session', 'Starts a new session' do
      banner <<-BANNER
        Usage: save-session (name)

        Saves the current session.
      BANNER

      def options(opts)
        opts.on :c, :commands, "Includes pry commands"
      end

      def process
        session = Pry.history.to_a.last(Pry.history.session_line_count)

        Dir.mkdir(SESSION_DIR) unless Dir.exists?(SESSION_DIR)
        File.open("#{SESSION_DIR}/#{args.first}", 'w') { |f| f.puts session}
      end
    end

    create_command 'load-session', 'Starts a new session' do
      # opts for later: [-sio] (name)
      banner <<-BANNER
        Usage: load-session (name)

        Loads a session.
      BANNER

      def options(opts)
        # TODO
        # opts.on :s, :silent,       "Silences both input and output"
        # opts.on :i, 'show-input',  "Shows only input"
        # opts.on :o, 'show-output', "Shows only output"
      end

      def process
        raise 'No sessions to load!' unless Dir.exists?(SESSION_DIR)
        puts
        _pry_.input = File.open("#{SESSION_DIR}/#{args.first}", 'r')
      end
    end

    create_command 'edit-session', 'Edits an existing session' do
      banner <<-BANNER
        Usage: edit-session (name)

        Edits a session.
      BANNER

      def options(opts) end

      def process
        raise 'No sessions to load!' unless Dir.exists?(SESSION_DIR)
        
        # Yes, cheating
        _pry_.input = StringIO.new("edit #{SESSION_DIR}/#{args.first}")
      end
    end

    create_command 'list-sessions', 'Lists all existing sessions' do
      banner <<-BANNER
        Usage: list-sessions (name)

        Lists sessions.
      BANNER

      def options(opts)
        opts.on :s, :sort, "Sorts sessions by [name|ctime|size]\nex: --sort name:[asc|desc]",
                argument: :required, as: Array, delimiter: ':'

        opts.on :g, :grep, "Greps for sessions by name", argument: :required, as: Regexp
      end

      def process
        raise 'No sessions to load!' unless Dir.exists?(SESSION_DIR)
        raise 'Cannot filter and grep!' if opts[:g] && opts[:f]

        # Mapper for transforming file names into a meta info container
        file_mapper = -> f {
          "#{SESSION_DIR}/#{f}".pipe { |path|
            FileMeta.new name: f, path: path, size: File.size(path), ctime: File.ctime(path)
          }
        }

        # Selecter for finding by name or regex
        selecter = (opts[:g] || args.first).pipe { |query|
          if query
            query.is_a?(Regexp) ?
              -> s { query.match s.name } :
              -> s { s.name == query }
          else
            -> s { s }
          end
        }
        
        # Sorter to arrange results
        sorter = if opts[:s] && %w(name size ctime).include?(opts[:s].first)
          opts[:s].first.pipe { |field|
            opts[:s][1] == 'asc' ? 
              -> a,b { a.send(field) <=> b.send(field) } :
              -> a,b { b.send(field) <=> a.send(field) }
          }
        else
          -> a,b { a.ctime <=> b.ctime }
        end

        Dir.entries(SESSION_DIR)
           .reject { |f| /^..?$/.match f } # Get rid of current and parent dir
           .map(&file_mapper)              # Map filenames to metainformation
           .select(&selecter)              # Select matches
           .sort(&sorter)                  # Sort those results
           .each { |f| output.puts f }     # Output them
      end
    end
  end
end

Pry.commands.import PrySession::Commands
