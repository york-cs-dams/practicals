# Checking the clarity of code and designs

This practical covers:

* Assessing the clarity of a design and its implementation via peer review
* Explaining the Ruby Style Guide and evaluating it with respect to your team's requirements
* Applying a static analysis tool to automatically check code for style

## Peer review

Your first task is to work with one or two teammates to review a piece of design work and its implementation. Select a couple of pieces of work that you'd like to review: these could be from earlier practicals, from your team's assessment, or from one of the open-source tools that have been used in practicals (such as [RSpec](https://github.com/rspec/rspec-core/) or [Parser](https://github.com/whitequark/parser/)).

Review some of the most recent changes (e.g., using Git) to your chosen project. Aim to highlight strengths and weaknesses of the code and the design relating to clarity. Focus on naming, documentation (including comments) and the narrative structure of the code. Are there tactics that you particularly like? Are they any recurring issues to which you could offer constructive criticism? Keep a brief summary of the discussion, as you will use this later in the practical.

**Note**: Code review is as at least as much about people as it is about code. Give special thought to the way in which you provide feedback. For example, compare "Why didn't you just do X?" with "Interesting. Would X work here?". How does each make you feel as the recipient of this feedback?

A simplistic but somewhat useful mnemonic for feedback is BOOST. Feedback should be:

* Balanced - include both good and bad points
* Observed - only give examples based on what you can see right now: don't include preconceptions or previous experience
* Objective - base feedback on factual evidence
* Specific - avoid broad statements and use specific examples to illustrate a comment
* Timely - feedback is more helpful when it is received soon after the event


## Styleguides

Using the summary of your discussions from part 1, read and discuss the [Ruby Style Guide](https://github.com/bbatsov/ruby-style-guide) with your reviewers. In particular, aim to answer the following questions:

* Does the style guide disallow any of the issues that you have identified? (For example, if you have identified that important values are hardcoded, does the style guide offer any guidelines that would improve matters?)
* Does the style guide encourage any of the strengths that you have identified?
* Does the style guide discourage any of the strengths? Does it encourage any of the weaknesses?

You will ultimately arrive at a modified version of the styleguide which you and your teammates may wish to adopt. Make a note of your modifications and discuss them with your entire team.

## Linting with Rubocop

Rubocop is a static analysis tool for Ruby that checks whether a project conforms to the Ruby style guide. (Nowadays this practice is often referred to as "linting"). Your final task is to assess whether or not Rubocop is a useful tool for your team, particularly with respect to improving the clarity of your code.

Start by running Rubocop on all of the code that you have developed in the practicals. You can do this by running: `rubocop`. The output will be a list of issues detected with your code, and with the code that I have provided.

In determining whether or not Rubocop will be useful for your team, you should consider at least the following:

* How useful is the documentation under `rubocop --help` and at the [project website](https://github.com/bbatsov/rubocop)?
* What does `rubocop --auto-correct` do?
* How can specific checks ("cops" in Rubocop parlance) be turned off or customised?
* Are there issues that you have identified in your code reviews that Rubocop cannot detect? Can Rubocop be extended to include any of these additional checks?

Finally, discuss in your team how you might change your process. When, if ever, do you want to run Rubocop on the work that you develop for your assessment? When, if ever, do you want to perform code reviews? How else might you aim to improve the clarity of your work?
