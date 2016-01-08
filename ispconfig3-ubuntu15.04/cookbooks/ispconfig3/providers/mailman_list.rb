include Chef::Mixin::ShellOut

def exists?
    cmd = shell_out("list_lists")
    cmd.stdout.downcase.include?(new_resource.name.downcase)
end

action :create do
    unless exists?
        execute "newlist #{@new_resource.name}" do
            command "newlist -q #{new_resource.name} #{new_resource.email} #{new_resource.password}"
        end
        @new_resource.updated_by_last_action(true)
    end
end
