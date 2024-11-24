import Firewalls
import IP

extension IP.Firewall
{
    public mutating
    func attach(whitelist:SearchbotWhitelist, of claimant:IP.Claimant)
    {
        self.claimants.append(.init(id: claimant, blocks: whitelist.blocks))
    }

    public mutating
    func attach(whitelist:GitHubWhitelist)
    {
        // var actions:IP.Claims<IP.Claimant> = .init(id: .github_actions)
        var webhook:IP.Claims<IP.Claimant> = .init(id: .github_webhook)
        // var other:IP.Claims<IP.Claimant> = .init(id: .github_other)

        // GitHub seems to use subsets of the GitHub Actions address space for its other
        // services, which creates overlapping ranges. Some of the addresses are also claimed
        // by Bingbot, I guess because Microsoft owns GitHub.

        // actions.extend(with: whitelist.actions)
        // actions.extend(with: whitelist.actionsMacOS)

        webhook.extend(with: whitelist.hooks)

        // These also overlap with Bingbot...

        // other.extend(with: whitelist.web)
        // other.extend(with: whitelist.api)
        // other.extend(with: whitelist.git)
        // other.extend(with: whitelist.importer)
        // other.extend(with: whitelist.importerGitHubEnterprise)
        // other.extend(with: whitelist.packages)
        // other.extend(with: whitelist.pages)
        // other.extend(with: whitelist.dependabot)

        // self.claimants.append(actions)
        self.claimants.append(webhook)
        // self.claimants.append(other)
    }
}
