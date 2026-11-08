require 'open3'

class GitWrapper

  def checkout_develop(force: false, update: false, quiet: false)
    directories = get_git_repos
    current_root = Dir.pwd
    for d in directories do
      output_str = "Updating #{d}..."
      Dir.chdir(d)
      begin
        if force
          Open3.capture3('git reset --hard')
        end
        Open3.capture3("git checkout develop")
        if update
          Open3.capture3("git fetch origin")
          Open3.capture3("git reset --hard origin/develop")
        end
        output_str += ' Done!'
      rescue RuntimeError => e
        output_str += " ERROR! #{e.message}. Continuing"
      end
      print "#{output_str}\n" unless quiet
      Dir.chdir(current_root)
    end
  end

  private

  def get_git_repos()
    directories = Dir.glob('*').select { |f| File.directory? f}
    for d in directories
      directories.delete(d) unless File.exist?(d + '/.git')
    end
    directories
  end
end
