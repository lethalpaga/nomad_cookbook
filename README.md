# nomad Cookbook

Install and configure Hashicorp's [nomad](https://nomadproject.io).

Based on [John Bellones's Vault cookbook](https://github.com/johnbellone/vault-cookbook)

## Requirements

TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
### Platforms

- SandwichOS

### Chef

- Chef 12.0 or later

## Attributes

TODO: List your cookbook attributes here.

e.g.
### nomad::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['nomad']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### nomad::default

TODO: Write usage instructions for each cookbook.

e.g.
Just include `nomad` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[nomad]"
  ]
}
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License

See [LICENSE.md]
