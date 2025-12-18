# Equation images

This foder holds all the equations used in the specification documents. This is necessary because Apache Fop has issue rendering MathML, which is used the PTZ Service specifications.

Each file contains one equation and must follow the MathML syntax. It is important to underline that files must have `.xml` extensions, otherwise XML calabash will not be able to parse the file.

Upon pushing, the system will automatically generate in background the `.svg` files. You will receive the generated images with a successive pull.
