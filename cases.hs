module Main where

import System.Environment
import Data.List
import Data.Char
import qualified Data.ByteString
import qualified Alfred as AL
import Happstack.Server (nullConf, simpleHTTP, toResponse, ok)

upperWordsList = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", "HTML", "CSS", "AT&T", "PHP"]
lowerWordsList = [ "to", "an", "and", "at", "as", "but", "by", "for", "if", "in", "on", "or", "is", "with", "a", "the", "of", "vs", "vs.", "via", "via", "en"]

toWordLower :: String -> String
toWordLower a = map toLower a

toWordUpper :: String -> String
toWordUpper a = map toUpper a

toFirstLetterUpper ::  [Char] -> [Char]
toFirstLetterUpper [] = []
toFirstLetterUpper (a:[]) = toUpper a : []
toFirstLetterUpper (a:ax) = toUpper a : toWordLower ax

toFirstLetterUpperOnly ::  [Char] -> [Char]
toFirstLetterUpperOnly [] = []
toFirstLetterUpperOnly (a:[]) = toUpper a : []
toFirstLetterUpperOnly (a:ax) = toUpper a : ax

toFirstLetterLowerOnly ::  [Char] -> [Char]
toFirstLetterLowerOnly [] = []
toFirstLetterLowerOnly (a:[]) = toLower a : []
toFirstLetterLowerOnly (a:ax) = toLower a : ax

toTitleCase ::  [Char] -> [Char]
toTitleCase [] = []
toTitleCase a
	| elem (toWordUpper a) upperWordsList = toWordUpper a
	| elem (toWordLower a) lowerWordsList = toWordLower a
	| otherwise = toFirstLetterUpper a

processLine ::  String -> (String -> String)  -> [String] -> String
processLine "" f [a] =  concatMap f $ words a
processLine c f [a] =   init $ concatMap (++ c) $ map f $ words a

lower :: [String] -> IO ()
lower a = do
	putStr $ procLower a

procLower :: [String] -> String
procLower [a] = toWordLower a

upper :: [String] -> IO ()
upper a = do
	putStr $ procUpper a

procUpper :: [String] -> String
procUpper [a] = toWordUpper a

sentence :: [String] -> IO ()
sentence a = do
	putStr $ procSentence a

procSentence :: [String] -> String
procSentence a = processLine " " toFirstLetterUpper a

title :: [String] -> IO ()
title a = do
	putStr  $ procTitle a

procTitle :: [String] -> String
procTitle a = toFirstLetterUpperOnly $ processLine " " toTitleCase a

camel :: [String] -> IO ()
camel a = do
	putStr  $ procCamel a

procCamel :: [String] -> String
procCamel a = toFirstLetterLowerOnly $ processLine "" toFirstLetterUpper a

slash :: [String] -> IO ()
slash a = do
	putStr  $ procSlash a

procSlash :: [String] -> String
procSlash a = processLine "/" toWordLower a

pascal :: [String] -> IO ()
pascal a = do
	putStr  $ procPascal a

procPascal :: [String] -> String
procPascal a = processLine "" toFirstLetterUpper a

cobra :: [String] -> IO ()
cobra a = do
	putStr $ procCobra a

procCobra :: [String] -> String
procCobra a =  processLine "_" toFirstLetterUpper a

dot :: [String] -> IO ()
dot a = do
	putStr $ procDot a

procDot :: [String] -> String
procDot a = processLine "." toWordLower a

dash :: [String] -> IO ()
dash a = do
	putStr $ procDash a

procDash :: [String] -> String
procDash a = processLine "-" toWordLower a

alfredScript :: [String] -> IO ()
alfredScript [input, caseStr ] = do
	putStr AL.begin
	if isInfixOf input "title"
		then do
			let caseConverted = procTitle [ caseStr ]
			putStr (AL.addItemBasic "HTCTitle" caseConverted caseConverted "Title Case")
		else putStr ""
	if isInfixOf input "lower"
		then do
			let caseConverted = procLower [ caseStr ]
			putStr (AL.addItemBasic "HTCLower" caseConverted caseConverted "Lower Case")
		else putStr ""
	if isInfixOf input "upper"
		then do
			let caseConverted = procUpper [ caseStr ]
			putStr (AL.addItemBasic "HTCUpper" caseConverted caseConverted "Upper Case")
		else putStr ""
	if isInfixOf input "sentence"
		then do
			let caseConverted = procSentence [ caseStr ]
			putStr (AL.addItemBasic "HTCSentence" caseConverted caseConverted "Sentence Case")
		else putStr ""
	if isInfixOf input "camel"
		then do
			let caseConverted = procCamel [ caseStr ]
			putStr (AL.addItemBasic "HTCCamel" caseConverted caseConverted "Camel Case")
		else putStr ""
	if isInfixOf input "slash"
		then do
			let caseConverted = procSlash [ caseStr ]
			putStr (AL.addItemBasic "HTCSlash" caseConverted caseConverted "Slash Case")
		else putStr ""
	if isInfixOf input "pascal"
		then do
			let caseConverted = procPascal [ caseStr ]
			putStr (AL.addItemBasic "HTCPascal" caseConverted caseConverted "Pascal Case")
		else putStr ""
	if isInfixOf input "cobra"
		then do
			let caseConverted = procCobra [ caseStr ]
			putStr (AL.addItemBasic "HTCCobra" caseConverted caseConverted "Cobra Case")
		else putStr ""
	if isInfixOf input "dot"
		then do
			let caseConverted = procDot [ caseStr ]
			putStr (AL.addItemBasic "HTCDot" caseConverted caseConverted "Dot Case")
		else putStr ""
	if isInfixOf input "dash"
		then do
			let caseConverted = procDash [ caseStr ]
			putStr (AL.addItemBasic "HTCDash" caseConverted caseConverted "Dash Case")
		else putStr ""
	putStr AL.end

acserver :: [String] -> IO ()
acserver [input] = simpleHTTP nullConf $ ok ("Hello, " ++ input ++ "!")


dispatch :: [(String, [String] -> IO ())]
dispatch =  [ ("lower", lower)
		 , ("upper", upper)
		 , ("sentence", sentence)
		 , ("title", title)
		 , ("camel", camel)		-- myGreatVariableName
		 , ("slash", slash)		-- my/great/variable/name
		 , ("pascal", pascal)		-- MyGreatVariableName
		 , ("cobra", cobra)		-- My_Great_Variable_Name
		 , ("dot", dot)			-- my.great.variable.name
		 , ("dash", dash)			-- my-great-variable-name
		 , ("alfredScript", alfredScript)
		 , ("acserver", acserver)
		]

main = do
	(command:args) <- getArgs
	let (Just action) = lookup command dispatch
	action args
