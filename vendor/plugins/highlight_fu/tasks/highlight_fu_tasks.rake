# This task is copied from the textile_editor_helper
# You can find this plugin at http://slateinfo.blogs.wvu.edu/plugins/textile_editor_helper/
namespace :highlight_fu do
  HIGHLIGHT_FU_ROOT = File.dirname(__FILE__) + '/..'
  HIGHLIGHT_FU_ASSETS = Dir[HIGHLIGHT_FU_ROOT + '/assets/**/*'].select { |e| File.file?(e) }
  
  desc 'Installs required assets'
  task :install do
    verbose = true
    HIGHLIGHT_FU_ASSETS.each do |file|
      path = File.dirname(file) + '/'
      path.gsub!(HIGHLIGHT_FU_ROOT, RAILS_ROOT)
      path.gsub!('assets', 'public')
      destination = File.join(path, File.basename(file))
      puts " * Copying %-50s to %s" % [file.gsub(HIGHLIGHT_FU_ROOT, ''), destination.gsub(RAILS_ROOT, '')] if verbose
      FileUtils.mkpath(path) unless File.directory?(path)      
      FileUtils.cp [file], path
    end    
  end
  
  desc 'Removes assets for the plugin'
  task :remove do
    HIGHLIGHT_FU_ASSETS.each do |file|
      path = File.dirname(file) + '/'
      path.gsub!(HIGHLIGHT_FU_ROOT, RAILS_ROOT)
      path.gsub!('assets', 'public')
      path = File.join(path, File.basename(file))
      puts ' * Removing %s' % path.gsub(RAILS_ROOT, '') if verbose
      FileUtils.rm [path]
    end
  end
end