require File.expand_path("../../capsum.rb", __FILE__)

Capistrano::Configuration.instance(true).load do

  namespace :deploy do
    desc 'Replace named files with a symlink to their counterparts in shared/'
    task :symlink_shared do
      if !exists?(:shared)
        abort 'You must specify which files to symlink using the "set :shared" command.'
      end
      shared.each do |path|
        if release_path.nil? || release_path.empty? || path.nil? || path.empty?
          raise "Release path or path are nil!"
        end
        run "rm -rf #{release_path}/#{path} && ln -nfs #{shared_path}/#{path} #{release_path}/#{path}"
      end
    end
  end

  before "deploy:finalize_update", "deploy:symlink_shared"
end
