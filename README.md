# Purr PR

Tired of formatting/writing the same PR text over and over again? Use Purr PR to create a simple formatting script!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'purr-pr'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install purr-pr
```

### Dependencies

This gem using [GitHub CLI tool](https://github.com/cli/cli) to conveniently create PRs, so you will need to [install it](https://github.com/cli/cli#installation) in order to use Purr PR.

## Usage

After installing gem, create a `purr.rb` file in the root of your git project. This file will describe your PRs.

### Configuration

Now you can use `purr.rb` file to create your formatting script

#### Body

As body is the biggest PR part there are a lot of helpers to edit it. The base format is a:

```ruby
body do
  # your edits
end
```

First of all the `use_template` method will simply copy the contents of `.github/pull_request_template.md` to a body buffer.
To use any other file as a template you can provide the path to it as an argument:

```ruby
body do
  use_template
  # or use_template '.github/some_other_template.md'
end
```

The above code will create a PR with body that has the contents of a PR template file, but this is what GitHub do by default, so then you'll probably want to apply some edits.

For the future edits lets say that the contents of `.github/pull_request_template.md` is 'foo-template'

To append or prepend some content to the buffer you can use corresponding methods:

```ruby
body do
  use_template
  append '-postfix'
  prepend '[STORY_NUMBER] '
end
```

It will create the next body: '[STORY_NUMBER] foo-template-postfix'.

To change some text in a buffer use the `replace` method:

```ruby
body do
  use_template
  append '-postfix'
  prepend '[STORY_NUMBER] '
  replace '[STORY_NUMBER]', with: 1337
end
```

=> '[1337] foo-template-postfix'.

To remove some text use the `delete` method:

```ruby
body do
  use_template
  append '-postfix'
  prepend '[STORY_NUMBER] '
  replace '[STORY_NUMBER]', with: 1337
  delete '-postfix'
end
```

=> '[1337] foo-template'.

You can conditionally clear the buffer with the `clear` method:

```ruby
body do
  use_template
  clear if argv.first == '--empty'
end
```

The above code will create the PR with empty body if the first argument is '--empty'.

##### Manual edits

You can also open the `$EDITOR` and manually edit the buffer text with `editor` method:

```ruby
body do
  use_template
  editor
end
```

The above config will allow you to edit your template before creating a PR.
Optionally you can provide file format to use syntax highlighting (the default is `:md`): `editor format: :html`.

##### Confirmation

If you whant to ensure that your edits are correct use `confirm` method, it will display you current buffer and ask Y/N confirmation to continue:

```ruby
body do
  use_template
  confirm
end
```

##### Helpers

There are some syntax sugar and helpers to be used as the arguments of above methods:

```ruby
body do
  append newline(3)     # => '\n\n\n'
  append space          # => ' '
  append current_branch # => Current git branch name
  append commits.last   # => Latest commit (for the current branch) message
  clear if argv.first == '--foo' # command line arguments are available too
end
```

The only argument for `newline` and `space` is their count.

##### Actions

To ask a Y/N question you can use `ask_yn` method:

```ruby
body do
  ask_yn 'wanna dance? (Y/N)', confirm: -> { append 'yeeesss' }, decline: -> { append 'nope :(' }
end
```

The first argument is a message, and `:confirm` and `:decline` arguments are for callbacks.

To ask for a custom input use the `ask` method:

```ruby
body do
  append(ask 'Story number: ', default: 1337)
end
```

It will prompt you to enter the story number and then append it to the buffer. If no input is provided the `:default` value will be used.
To prompt for multiline input use `multiline: true`, it will prompt for the next line untill you input two empty lines in a row.
Use `newline: true` to append an empty line after the input.

To read a file there is a `read_file` method:

```ruby
body do
  append(read_file('Gemfile'))
end
```

The above config will append your Gemfile content to the buffer

To conditionally finish the editing and create a PR use `finish`:

```ruby
body do
  ask_yn 'are you a duck? (Y/N)', confirm: -> { append 'quack' }, decline: -> { finish }
end
```

If you want to finish editing and cancel the PR creating you should use `interrupt` instead

#### Title

For PR title you can use the same block formatting as for the body:

```ruby
title do
  story_number = "[#{current_branch}]"

  append story_number
  append ' my aweasome PR: '
  append commits.last
end
```

Or simply do:

```ruby
title 'My static PR title'
```

The first argument will be the initial title before editing, so:

```ruby
title 'Story#' do
  append 1337
end
```

Will create a title 'Story#1337'

#### Assignee

To assign someone to a PR use `assignee` or `self_assign` options:

```ruby
assignee '@JohnDoe'
# or to assign yourself:
self_assign
```

#### Base branch

If you want to change the default base branch use `base` option:

```ruby
base 'develop'
```

#### Draft PRs

To create draft PR use `draft` option:

```ruby
draft
# or
draft true
```

#### Labels

To add PR labels use `labels` or `label` options:

```ruby
labels ['bug', 'duplicate'] # to add as an array
label 'documentation' # to add a single label
```

The above code will add `bug`, `duplicate` and `documentation` labels to the PR

#### Reviewers

To add reviewers use `reviewers` or `reviewer` options:

```ruby
reviewers ['@JohnDoe', '@BoJackHorseman'] # to add as an array
reviewer '@FooBar' # to add a single reviewer
```

The above code will add `@JohnDoe`, `@BoJackHorseman` and `@FooBar` as the reviewers to the PR

Works with teams as well:

```ruby
reviewer 'my_organisation/code_revievers'
```


#### Disabling maintainer edit

To disable/reenable edits from maintainer use `maintainer_edit` or `no_maintainer_edit` options:

```ruby
maintainer_edit false
no_maintainer_edit # the same as above
```

### Finally, create a PR!

Simply call `purr` and it will create a PR for you via [GitHub CLI](https://github.com/cli/cli) according to your configuration file. Note that you may need to log in first with `gh auth login`.

#### Scripting is the key

The inline edits is pretty simple, but pretty useless as well, so don't forget that you can use any ruby code here to format your buffer.
A nice example:

```ruby
title 'Story: ' do
  story_number = current_branch.gsub('/').first # e.g. '1337/do-something'

  append story_number
  append space

  if commits.count == 1
    append commits.last
  else
    append(ask 'Title: ', default: commits.last)
  end
end

body do
  story_number = current_branch.gsub('/').first

  use_template

  # Story number
  replace '<STORY NUMBER>', with: story_number

  # PR Title and details
  if commits.count == 1
    story_title = details = commits.last
  else
    story_title = ask 'Title: ', default: commits.last
    details = ask 'Details: ', default: commits.last
  end
  replace 'Story Title', with: story_title
  replace 'Details go here', with: details

  # check the PR type checkboxes
  case argv.first
  when '--feature'
    replace '- [ ] New feature', with: '- [x] New feature'
  when '--bugfix'
    replace '- [ ] Bug fix', with: '- [x] Bug fix'
  when '--docs'
    replace '- [ ] Documentation', with: '- [x] Documentation'
  end

  editor # to ensure and fix something
end

draft if argv.include?('--draft')
self_assign
reviewer '@MyFellowReviewer'
label 'bug' if argv.first == '--bugfix'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `rake install`. To release a new version, update the version number in [version.rb](lib/purr_pr/version.rb), and then run `rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ARtoriouSs/purr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ARtoriouSs/purr/blob/master/CODE_OF_CONDUCT.md).

## [License](LICENSE.txt)

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Purr project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ARtoriouSs/purr/blob/master/CODE_OF_CONDUCT.md).
