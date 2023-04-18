<div align="center" style="display:grid;place-items:center;">
<p>
    <a href="https://vlang.io/" target="_blank"><img width="80" src="https://raw.githubusercontent.com/vlang/v-logo/master/dist/v-logo.svg?sanitize=true" alt="V logo"></a>
</p>
    <h1>The V Programming Language Documentation</h1>

<div align="center">
    <a href="https://docs.vosca.dev/">docs.vosca.dev</a>
</div>

</div>

<p></p>

<div align="center" style="display:grid;place-items:center;">

[![Association Official Project][AssociationOfficialBadge]][AssociationUrl]
[![Modules][ModulesBadge]][ModulesUrl]

</div>

This documentation is based on the original V documentation that can be found in
[vlang/v](https://github.com/vlang/v/blob/master/doc/docs.md).
It has been heavily rewritten for most of the articles, although some articles have remained almost
unchanged.

The purpose of this documentation is to provide more detailed information about V than the original
documentation, and also to provide a better reading experience, as the documentation is hosted on a
separate site.

Also, dividing the documentation into separate articles makes it easier to delve into each article,
as well as easier to add new articles or entire sections.

Learn more about documentation in the [blog post](https://blog.vosca.dev/meet-new-documentation/).

## Build the documentation

To build the documentation, run the following command:

```bash
v install
npm run generate
```

This will install all dependencies, and generate the documentation in the `output` directory.

To run documentation server, run the following command:

```bash
npm run serve
```

If you want change styles, make sure you have installed `sass` globally:

```bash
npm install sass
```

And run the following command to watch for changes:

```bash
npm run sass-watch
```

## License

This project is under the **MIT License**. See the
[LICENSE](https://github.com/vlang-association/docs/blob/master/LICENSE)
file for the full license text.

[AssociationOfficialBadge]: https://vosca.dev/badge.svg

[ModulesBadge]: https://vosca.dev/modules-badge.svg

[AssociationUrl]: https://vosca.dev

[ModulesUrl]: https://modules.vosca.dev
