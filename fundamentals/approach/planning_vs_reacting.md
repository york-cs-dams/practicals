# Planning vs. reacting

The purpose of this tutorial is to consider different ways in which a software design problem can be approached. In other words, this is an examination of how a (light) software engineering process can be applied in your work.

*Note that this tutorial will not work with the Ruby installation on the CS student lab machines. You can instead use the Vagrant setup for DAMS practicals as discussed in at the end of the [Vagrant tutorial](../tools/vagrant.md).*


## Planning

Consider the problem specification below.

**Problem:** Ten-pin bowling is a popular pastime, but the scoring system can be a little confusing. You have been awarded a contract to design and implement the scoring algorithm for the computer systems used by a popular ten-pin bowling chain. You are to implement scoring as [described here](http://www.bowling2u.com/trivia/game/scoring.asp). You may assume that other systems will (periodically) send you a number (of pins that have been knocked down on each throw) and in return expect to receive a number (which represents the total score for that player).

Begin to work out a design that can solve this problem. You might like to use either a UML sequence or class diagram to help guide your design. (Sketching a diagram on paper will be sufficient). Compare your design with those of your teammates.


## Reacting

Consider again the problem specification above. Apply test-driven development to produce a design for a solution to the problem. Remember that TDD disallows us from writing code for which there is not already a failing test. An empty test file and an empty implementation file have been provided for you, and you can run the tests with `vado rake test:approach:bowling`.

Compare the design that you arrive via TDD with your original design on paper. Note down all of the differences. Why might each difference have arisen? Compare your thoughts with those of your teammates.
