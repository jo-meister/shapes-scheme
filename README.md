# Example
> mit-scheme was used for all testing of shapes.scm

Run program: scheme --quiet < test.scm

Output for given test.scm:

Unable to open xxxx.dat for reading.

Incorrect number of arguments.

Box: Cube#1, Length=1.00, Width=1.00, Height=1.00
        Surface Area: 6.00, Volume: 1.00

Box: Cube#2, Length=2.00, Width=2.00, Height=2.00
        Surface Area: 24.00, Volume: 8.00

Torus: Donut#1, Small Radius=1.00, Big Radius=1.00
        Surface Area: 39.48, Volume: 19.74

Cylinder: Cyl#1, Radius=1.00, Height=1.00
        Surface Area: 12.57, Volume: 3.14

Box: Case#1, Length=2.00, Width=4.00, Height=6.00
        Surface Area: 88.00, Volume: 48.00

Box: Case#2, Length=10.50, Width=21.00, Height=10.50
        Surface Area: 1102.50, Volume: 2315.25

Sphere: UnitSphere, Radius=1.00
        Surface Area: 12.57, Volume: 4.19

Sphere: LargeSphere, Radius=100.00
        Surface Area: 125663.71, Volume: 4188790.20

Torus: Donut#2, Small Radius=3.00, Big Radius=7.00
        Surface Area: 829.05, Volume: 1243.57

Cylinder: Cyl#2, Radius=1.00, Height=2.00
        Surface Area: 18.85, Volume: 6.28

Box: Case#1, Length=2.00, Width=4.00, Height=6.00
        Surface Area: 88.00, Volume: 48.00

Box: Case#2, Length=10.50, Width=21.00, Height=10.50
        Surface Area: 1102.50, Volume: 2315.25

There are 6 shapes.

There are 4 shapes.


# shapes.dat
Contains shapes to be loaded into a list in shapes.scm.


# shapes.scm
Processes shapes and handles requests.

Test conditions: condition operator value
*   Conditions: "type", "area", "volume"
*   Operators: “==”, “!=”, “>=”, “<=”, “>”, “<”
*   Values: numbers for are and volume commands and strings for type command
Creates a sublist from all shapes that contains the shapes that satisfy the conditions.

Valid Commands
*   count: prints the number of satisfying shapes
*   print: prints the name, dimensions, surface area, and volume of each satisfying shape
*   min: finds the minimum surface area and volume of the satisfying shapes
*   max: finds the maximum surface area and volume of the satisfying shapes
*   total: finds the total surface area and volume of the satisfying shapes
*   avg: finds the average surface area and volume of the satisfying shapes