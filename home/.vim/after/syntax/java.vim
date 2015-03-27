" Java 8 lambdas, see http://vi.stackexchange.com/questions/1905/vims-syntax-highlighting-considers-a-lambda-in-java-an-error
syn clear javaError
syn match javaError "<<<\|\.\.\|=>\|||=\|&&=\|\*\/"
syn match javaFuncDef "[^-]->"
