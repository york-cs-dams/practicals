# Achieving extensible code

This practical covers:

* Implementing a middleware architecture (for ordering pizzas)
* Selecting and implementing an appropriate observer architecture (for the pizza kitchen)
* Applying a plug-in architecture (to your code metrics tools from earlier practicals)

## Implementing a middleware architecture

Your first task is to refactor the code in the `middleware` directory to use a middleware architecture, as described in the middleware lecture.

The current version of the code consumes customer orders and applies a number of transformations (e.g., discounts, loyalty deals, etc). Each restaurant owner would like the flexibility to turn on and off certain transformations at will, and to be able to add their own custom transformations. This calls for a middleware architecture...

Aim to extract each of the transformations into its own piece of middleware, whilst keeping all of the tests passing. (You will need to refactor or reorganise the tests). You will know that you have finished when each transformation could be extracted into its own Ruby gem, and deployed independently of the core application.
