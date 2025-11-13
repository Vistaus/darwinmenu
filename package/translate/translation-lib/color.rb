module Color
    MAP = {
        red:    "\e[31m",
        green:  "\e[32m",
        yellow: "\e[33m",
        blue:   "\e[34m",
        cyan:   "\e[36m",
        dim:    "\e[2m",
        default:"\e[0m"
    }

    def self.echo(msg, color = :default)
        puts "#{MAP[color]}#{msg}#{MAP[:default]}"
    end
end
