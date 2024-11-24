import Firewalls
import IP

extension IP.Firewall
{
    public mutating
    func attach(whitelist:SearchbotWhitelist, of entity:IP.WhitelistEntity)
    {
        self.whitelists.append(.init(id: entity, blocks: whitelist.blocks))
    }

    public mutating
    func attach(whitelist:GitHubWhitelist)
    {
        var actions:IP.Whitelist = .init(id: .github_actions)
        var webhook:IP.Whitelist = .init(id: .github_webhook)
        var other:IP.Whitelist = .init(id: .github_other)

        actions.extend(with: whitelist.actions)
        actions.extend(with: whitelist.actionsMacOS)

        webhook.extend(with: whitelist.hooks)

        other.extend(with: whitelist.web)
        other.extend(with: whitelist.api)
        other.extend(with: whitelist.git)
        other.extend(with: whitelist.importer)
        other.extend(with: whitelist.importerGitHubEnterprise)
        other.extend(with: whitelist.packages)
        other.extend(with: whitelist.pages)
        other.extend(with: whitelist.dependabot)

        self.whitelists.append(actions)
        self.whitelists.append(webhook)
        self.whitelists.append(other)
    }
}
