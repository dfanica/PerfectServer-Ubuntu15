unless shell_out('list_lists').stdout.downcase.include?(node['mailman']['list_name'])
    # unless list_name_exists?
    execute "newlist #{node['mailman']['list_name']}" do
        command "newlist -l en -q mailman #{node['mailman']['email']} #{node['mailman']['password']}"
    end
end
