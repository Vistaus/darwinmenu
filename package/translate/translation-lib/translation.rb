#!/usr/bin/env ruby
# encoding: UTF-8

require_relative 'color'

COMMANDS = %w[extract build merge status help]
RESTART_FLAG = '--restart'

def run_extract
    system("ruby #{__dir__}/extract.rb")
end

def run_build(restart = false)
  system("ruby #{__dir__}/build.rb")
  if restart
    Color.echo "[translation] Restarting plasmashell to apply translations...", :cyan
    system("kquitapp6 plasmashell")
    sleep 1
    system("nohup plasmashell > /dev/null 2>&1 & disown")
  end
end

def run_merge
    system("ruby #{__dir__}/merge.rb")
end

def run_status
    translations_path = File.expand_path('../', __dir__)
    path = File.join(translations_path, 'Status.md')
    if File.exist?(path)
        puts File.read(path)
    else
        Color.echo "[status] Status.md not found. Run 'merge' first.", :yellow
    end
end

def show_help
    puts <<~HELP
    Usage: ./translation <command> [--restart]

    Commands:
    extract   Extract translatable strings into template.pot
    build     Compile .po files into .mo and install them
    merge     Merge template.pot into existing .po files
    status    Show translation progress table
    help      Show this help message

    Options:
    --restart   Restart plasmashell after build to apply translations
    HELP
end

command = ARGV[0]
restart = ARGV.include?(RESTART_FLAG)

unless COMMANDS.include?(command)
    Color.echo "[translation] Unknown command: #{command.inspect}", :red unless command.nil?
    show_help
    exit 1
end

case command
when 'extract' then run_extract
when 'build'   then run_build(restart)
when 'merge'   then run_merge
when 'status'  then run_status
when 'help'    then show_help
end
