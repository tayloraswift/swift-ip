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
