# Achieving extensible code

This practical covers:

* Implementing a middleware architecture (for ordering pizzas)
* Selecting and implementing an appropriate observer architecture (for the pizza kitchen)
* Applying a plug-in architecture (to your code metrics tools from earlier practicals)

## Implementing a middleware architecture

Your first task is to refactor the code in the `middleware` directory to use a middleware architecture, as described in the middleware lecture.

The current version of the code consumes customer orders and applies a number of transformations (e.g., discounts, loyalty deals, etc). Each restaurant owner would like the flexibility to turn on and off certain transformations at will, and to be able to add their own custom transformations. This calls for a middleware architecture...

Aim to extract each of the transformations into its own piece of middleware, whilst keeping all of the tests passing. (You will need to refactor or reorganise the tests). You will know that you have finished when each transformation could be extracted into its own Ruby gem, and deployed independently of the core application.

## Selecting and implementing an appropriate observer architecture

Your second task is to consider the code in the `observer` directory, giving particular attention to the unit tests (which are currently failing). Your goal is to get the tests to pass, by designing and implementing an appropriate observer architecture.

The lecture on observers provides the background for this exercise, and covers three styles of observer. Consider whether any of the styles in the lecture are appropriate here. Implement an observer architecture that allows you to pass all of the test cases.

Hint: it should be possible to pass all of the test cases without changing any of the assertions, though to do so you might need to design a more sophisticated observer architecture than the one described in the lecture.

## Applying a plug-in architecture

Finally, you should apply the plug-in architecture from the lecture to the code metrics tool. Your aim is to make it possible for any of the metrics to be specified as a plug-in. In other words, it should be possible for any metric to be shipped in its own gem, separate to (and depending on) a gem containing the core of the code metrics tool. This would allow, for example, users to pick and choose which metrics are available.

The lecture on plug-ins builds up a fairly idiomatic architecture that you should re-use. To begin with, you might like to look through the code in `plugins` which provides implementations and unit tests for the `Plugins` and `Pluggable` modules.

You will likely need to change to the `Pluggable` module: which currently assumes that a plug-in comprises a module that is included into some class, and a module that is extended into a class. This is probably not appropriate for your needs. Decide what your plug-in architecture does need, and change `Pluggable` accordingly.

As a bonus, also provide a separate plug-in architecture for reporting, such that different reporting strategies (e.g., to the command line, to JSON, to HTML) could be loaded from separate plug-ins.

Hint: For some inspiration for richer plug-in architectures, take a look at [Roda](https://github.com/jeremyevans/roda/blob/2.5.1/lib/roda.rb#L168).
