require "pry-session/version"
require 'pry'

module PrySession
  SESSION_DIR = "#{Dir.home}/.pry-sessions"

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

      def options(opts) end

      def process
        session = Pry.history.to_a.last(Pry.history.session_line_count)

        Dir.mkdir(SESSION_DIR) unless Dir.exists?(SESSION_DIR)
        File.open("#{SESSION_DIR}/#{args.first}", 'w') { |f| f.puts session}
      end
    end

    create_command 'load-session', 'Starts a new session' do
      banner <<-BANNER
        Usage: load-session (name)

        Loads a session.
      BANNER

      def options(opts) end

      def process
        raise 'No sessions to load!' unless Dir.exists?(SESSION_DIR)
        puts
        _pry_.input = File.open("#{SESSION_DIR}/#{args.first}", 'r')
      end
    end
  end
end

Pry.commands.import PrySession::Commands
