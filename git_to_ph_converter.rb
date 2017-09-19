require 'dotenv/load'
require 'octokit'
require 'pry'

Octokit.configure do |c|
  c.login = ENV['GITHUB_LOGIN']
  c.password = ENV['GITHUB_PASSWORD']
end

ph_repos = [{'yield': 3}, {'dev-tracker': 1 }, {'dpl-redesign': 2}, {'dash': 4},
            {'oz': 5}, {'portal': 6}, {'dps-website': 7}, {'dps-react-assessment': 8},
            {'whistle-mobile': 9}, {'whistle-web': 10}, {'whistle-backend': 11}, {'whistle-pushn': 12},
            {'dpl-rails': 13}, {'whistle-docker': 14}, {'kingdom-music': 15}]

private_repos = Octokit.org_repos('devpointstudios', { type: 'all' })

private_repos.each do |git_repo|
  ph_repo_name = ''

  ph_repo = ph_repos.find do |ph_repo|
    ph_repo_name = ph_repo.keys.first.to_s
    ph_repo_name == git_repo[:name]
  end

  if ph_repo.nil?
    ph_repo = ph_repos.find do |ph_repo|
      ph_repo_name = ph_repo.keys.first.to_s
      ph_repo_name == git_repo[:name].gsub('_', '-')
    end
  end

  begin
    `git clone #{git_repo[:ssh_url]} &&
     cd #{git_repo[:name]} &&
     git remote add ph ssh://git@phabricator.devpointstudios.com/diffusion/#{ph_repo[ph_repo_name.to_sym]}/#{ph_repo_name}.git &&
     git push ph master &&
     cd .. &&
     rm -rf #{git_repo[:name]}`
     `rm -rf #{git_repo[:name]}`
  rescue => e
    `rm -rf #{git_repo[:name]}`
    next
  end
end
