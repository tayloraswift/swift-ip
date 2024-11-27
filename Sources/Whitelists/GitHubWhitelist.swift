import IP
import JSON

@frozen public
struct GitHubWhitelist
{
    var hooks:[IP.AnyCIDR]
    var web:[IP.AnyCIDR]
    var api:[IP.AnyCIDR]
    var git:[IP.AnyCIDR]
    var importer:[IP.AnyCIDR]
    var importerGitHubEnterprise:[IP.AnyCIDR]
    var packages:[IP.AnyCIDR]
    var pages:[IP.AnyCIDR]
    var actions:[IP.AnyCIDR]
    var actionsMacOS:[IP.AnyCIDR]
    var dependabot:[IP.AnyCIDR]

    init(hooks:[IP.AnyCIDR],
        web:[IP.AnyCIDR],
        api:[IP.AnyCIDR],
        git:[IP.AnyCIDR],
        importer:[IP.AnyCIDR],
        importerGitHubEnterprise:[IP.AnyCIDR],
        packages:[IP.AnyCIDR],
        pages:[IP.AnyCIDR],
        actions:[IP.AnyCIDR],
        actionsMacOS:[IP.AnyCIDR],
        dependabot:[IP.AnyCIDR])
    {
        self.hooks = hooks
        self.web = web
        self.api = api
        self.git = git
        self.importer = importer
        self.importerGitHubEnterprise = importerGitHubEnterprise
        self.packages = packages
        self.pages = pages
        self.actions = actions
        self.actionsMacOS = actionsMacOS
        self.dependabot = dependabot
    }
}
extension GitHubWhitelist
{
    public
    func add(to claims:inout [IP.Claims])
    {
        // var actions:IP.Claims = .init(id: .github_actions)
        var webhook:IP.Claims = .init(id: .github_webhook)
        // var other:IP.Claims = .init(id: .github_other)

        // GitHub seems to use subsets of the GitHub Actions address space for its other
        // services, which creates overlapping ranges. Some of the addresses are also claimed
        // by Bingbot, I guess because Microsoft owns GitHub.

        // actions.extend(with: whitelist.actions)
        // actions.extend(with: whitelist.actionsMacOS)

        webhook.extend(with: self.hooks)

        // These also overlap with Bingbot...

        // other.extend(with: whitelist.web)
        // other.extend(with: whitelist.api)
        // other.extend(with: whitelist.git)
        // other.extend(with: whitelist.importer)
        // other.extend(with: whitelist.importerGitHubEnterprise)
        // other.extend(with: whitelist.packages)
        // other.extend(with: whitelist.pages)
        // other.extend(with: whitelist.dependabot)

        // claims.append(actions)
        claims.append(webhook)
        // claims.append(other)
    }
}
extension GitHubWhitelist
{
    @frozen public
    enum CodingKey:String, Sendable
    {
        case hooks
        case web
        case api
        case git
        case github_enterprise_importer
        case packages
        case pages
        case importer
        case actions
        case actions_macos
        case dependabot
    }
}
extension GitHubWhitelist:JSONObjectDecodable
{
    public
    init(json:JSON.ObjectDecoder<CodingKey>) throws
    {
        self.init(hooks: try json[.hooks]?.decode() ?? [],
            web: try json[.web]?.decode() ?? [],
            api: try json[.api]?.decode() ?? [],
            git: try json[.git]?.decode() ?? [],
            importer: try json[.importer]?.decode() ?? [],
            importerGitHubEnterprise: try json[.github_enterprise_importer]?.decode() ?? [],
            packages: try json[.packages]?.decode() ?? [],
            pages: try json[.pages]?.decode() ?? [],
            actions: try json[.actions]?.decode() ?? [],
            actionsMacOS: try json[.actions_macos]?.decode() ?? [],
            dependabot: try json[.dependabot]?.decode() ?? [])
    }
}
