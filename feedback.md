# Grocery Store

<!--

Reflection Question Answers:

1. Raising an ArgumentError stops the program and says that the method was invoked incorrectly. Also acceptable: answers about informing developers that the method was used incorrectly
2. `all` and `find` methods are class methods because they don't interact with a specific instance
3. The relationship between order and customer is many to one, where one customer may have many orders. It was similar in Solar System, where it was one solar system may have many planets. If the student says "Order has one Customer," that's also correct, since that's what's most closely pulled from the project requirements
4. In the CSV file, the relationships between order and customer are tracked through ID numbers. In our code, because we have OO and composition, we didn't use ID numbers
5. This question is a qualitative question about TDD

 -->

<!-- Instructors: The checkmarks are already there, so just delete them for any line items that aren't met. -->

## Major Learning Goals/Code Review

<!-- Instructors: Feel free to practice creating specific feedback by referencing a line of code if you'd like. For example, you may say something like "nice custom method in `calculator.rb` line 42." This is optional. -->

| Criteria | yes/no, and optionally any details/lines of code to reference |
| --- | --- |
The `Customer` and `Order` classes have appropriate `attr_` helpers for instance variables | ✔️
The `CSV` library is used in `.all` methods, and not in `.find` methods | ✔️
Appropriately parses the product data from CSV file in `Order.all` | ✔️
`Order.all` calls `Customer.find` to set up the composition relation | ✔️
Practices git with at least 3 small commits and meaningful commit messages | ✔️

## Functional Requirements

| Functional Requirement | yes/no |
| --- | --- |
All of the wave 1 tests in `Customer` pass | ✔️
All of the wave 1 tests in `Order` pass | ✔️
All of the wave 2 tests in `Customer` pass | ✔️
All of the wave 2 tests in `Order` pass | ✔️

## Overall Feedback

| Overall Feedback | Criteria | yes/no |
| --- | --- | --- |
| Green (Meets/Exceeds Standards) | 4+ in Code Review && 3+ in Functional Requirements | ✔️
| Yellow (Approaches Standards) | 2+ in Code Review && 2+ in Functional Requirements | ✔️
| Red (Not at Standard) | 0,1 in Code Review or 0,1 in Functional Reqs, or assignment is breaking/doesn’t run with less than 5 minutes of debugging | ✔️

<!-- ### Additional Feedback -->

<!-- Instructors, feel free to ignore this section if there's nothing else to add. -->

## Code Style Bonus Awards

<!-- Instructors: Please strike a balance between liberal/stingy with these. These are simply built-in pieces of positive feedback; use this to encourage and push students towards a cleaner code style! -->

Was the code particularly impressive in code style for any of these reasons (or more...?)

| Quality | Yes? |
| --- | --- |
| Perfect Indentation | ✅
| Elegant/Clever | ✅
| Descriptive/Readable | ✅
| Concise | ✅
| Logical/Organized | ✅
