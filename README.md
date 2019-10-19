# Committee

> **Reminder**: While `Committee` is working great for my own use-case, there can be occasional bugs every now and then, if your workflow rely heavily on a Git workflow, proceed at your own risk. Otherwise a PR is very much welcomed!
---

Committee is a supercharged ⚡️ git hooks manager in pure Elixir.

What does supercharged mean? This is what supercharged means.

Supercharged means:

- You get to write ***code*** with your git hooks.
- You get to write ***Elixir*** code with your git hooks.
- You get to write ***any*** Elixir code with your git hooks.
- ***Any. Elixir. Code. ⚡️***

[Read on](https://github.com/edisonywh/committee#usage) to find out more!

## Installation

Get the latest version from [Hex](https://hex.pm/packages/committee)

```elixir
def deps do
  [
    {:committee, "~> 0.1.2", only: :dev, runtime: false}
  ]
end
```

## Usage

*Documentation can be also be found over on [HexDocs](https://hexdocs.pm/committee).*

After installing `Committee`, all you have to do is run

> `mix committee.install`

*Your existing git hooks will be backed-up and renamed from `hook` to `hook.old`*

You should see a `.committee.exs` file being generated, that's where you'll be writing your hooks.

The file should look something like this:

```elixir
defmodule YourApp.Commit do
  use Committee
  import Committee.Helpers, only: [staged_files: 0]

  # ...
  # ...
  #
  # ## Example:
  #
  #   def pre_commit do
  #     System.cmd("mix", ["format"] ++ staged_files())
  #     System.cmd("git", ["add"] ++ staged_files())
  #   end
  #
  # ...
  #
end
```

To run code for a hook, write a function with the same name (in `snake_case`) as that hook. For a full list of git hooks in the wild, [checkout this list over here](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).

To **abort** a commit, return in the form of `{:halt, reason}`.
To **print** a success message, return in the form of `{:ok, message}`.

If you find that Committee does not do what you want (do let me know how to improve!) and you want to stop using it, you can run the built-in uninstallation task: `mix committee.uninstall`. **This will restore your existing hooks backup too**.

For a list of `Committee` supported hooks, checkout `Committee.__hooks__/0`
For a list of `Committee` provided helpers (such as `staged_files/0`, `branch_name/0`, checkout `Committee.Helpers`)

*Currently only `pre_commit` and `post_commit` are supported, this is mostly because I haven't tested the other ones, rather than any technical limitation, but I don't see why it won't work for the others. PRs are welcomed!*

### What are git hooks?
If you're reading this, you're probably familiar with Git. We are all used to terms like `commit`, `rebase`, but did you know that Git ships with the ability to run a hook/callback when you run these actions?

This effectively means you can write code that gets executed when you do a `git commit`, or when you're commencing a `rebase`. Exciting innit? :)

### What is `Committee` trying to solve?
Git hooks are great, but in my experience, there are two issues with them:

#### 1) Hassle to set-up
I find that it's not exactly straightforward to write git hooks, here's my own flow of writing a git hook (true story):

- read up about the amazing git hooks (like you're doing now)
- navigate into `.git/hooks`
- `vim pre-commit`
- *writes in bash* <sup>1</sup>
- make `pre-commit` into an executable.
- *Wait, how do you make it into an exectuable?*
- *googles for 5 mins*
- Ah, `chmod +x pre-commit`

I wanted an easier process for myself, but also read on to find out more.

#### 2) Difficult to share with team
Git hooks live in the `.git/hooks/` folder, and **`.git` folder isn't versioned**, this means that whatever you've just done in the [previous step](https://github.com/edisonywh/committee#step-1) would not work for your other team members.

No biggie aye? You just have to get **each and every one** of your teammate to repeat step 1.

Did I also mentioned that if you decided to update the `pre-commit` script (for example, you have a change in branchs' naming convention), you'd have to again, convince everyone in your team to repeat step 1?

*Yup.*

#### Get yourself a `Committee`!

The premise of `Committee` is simple, it solves the aforementioned problems like so:

> Hassle to set-up

Well for starters, you don't have to write any bash script<sup>1</sup>. Bash scripts are great, but wouldn't you rather write Elixir?

Also, you dont have to care about things like making a file executable. `Committee` will handle that for you :)

> Difficult to share with team

`Committee` exposes an easy mix task to install itself.

To share it with your team, all you have to do is to put `mix committee.install` in one of your onboarding script. **It's a one-time installation**, and from then on, any updates you make to `.committee.exs` (`Committee`'s configuration file) will become **immediately available to your team mates**.

*No fuss, no muss.*

### What are some alternatives?

#### Husky
Husky is great, it's a popular git hook manager in JavaScript-land. It is not limited to just JS, it also works for any other languages, including Elixir.

The only downside is that you'd need to set up `package.json` to include the `husky` dependency. I figured not every Elixir project would have `package.json` (for example when developing a library), hence `Committee`.

Husky is a much more battle-proven solution, and works for most scenarios (especially if you already have a `package.json`), so definitely go for that if suits your use case.

#### Lefthook
A project from Evil Martian. This project is really interesting, it is written in Go, works for any language by using a language-agnostic `.yml` config file. I like the idea that it's taking.

I was really contemplating using Lefthook, but I decided to take up a sort of challenge to come up with an Elixir-like hook manager, so well here we are..

#### Other Elixir Alternatives
There are few more Elixir-centric packages, like:

- [husky-elixir](https://github.com/spencerdcarlson/husky-elixir) (I'm not sure if it's officially affliated with the JavaScript library)
- [elixir_git_hooks](https://github.com/qgadrian/elixir_git_hooks)
- [elixir-pre-commit](https://github.com/dwyl/elixir-pre-commit)

They all look great, but all hinges on using `config.exs` to do configuration <sup>*Now that I'm writing this out, I realised I'm the outlier here..*</sup>, which works, but I decided to be a little bit more creative, and take this Elixir thing a step further.

Thus born `Committee`, which allows you to write any Elixir code in a `.committee.exs` file, because why not?

> <sup>1</sup> This is not always the case, you can change the [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) to run your code with other shell/languages, such as `ruby`.

---

## Contributions
Contributions are very welcomed, but please first [open an issue](https://github.com/edisonywh/committee/issues/new) so we can align and discuss before any development begins.

## License
View [License](https://github.com/edisonywh/committee/blob/master/LICENSE)
