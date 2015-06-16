<?php

/**
 * FunPlus_Sniffs_Classes_OpeningClassBraceKernighanRitchieSniff.
 *
 * PHP version 5
 *
 * @category  PHP
 * @package   PHP_CodeSniffer
 * @author    Junjie.Ning
 */
class FunPlus_Sniffs_Classes_OpeningClassBraceKernighanRitchieSniff implements PHP_CodeSniffer_Sniff {
	/**
	 * @var bool
	 */
	public $checkClass = true;
	/**
	 * @var bool
	 */
	public $checkInterface = true;

	/**
	 * Registers the tokens that this sniff wants to listen for.
	 * @return array
	 */
	public function register() {
		return array(
			T_CLASS,
			T_INTERFACE,
		);
	}

	/**
	 * Processes this test, when one of its tokens is encountered.
	 *
	 * @param PHP_CodeSniffer_File $phpcsFile The file being scanned.
	 * @param int $stackPtr The position of the current token in the
	 *                                        stack passed in $tokens.
	 *
	 * @return void
	 */
	public function process(PHP_CodeSniffer_File $phpcsFile, $stackPtr) {
		$tokens = $phpcsFile->getTokens();
		if (isset($tokens[$stackPtr]['scope_opener']) === false) {
			return;
		}
		if (($tokens[$stackPtr]['code'] === T_CLASS
				&& (bool)$this->checkClass === false)
			|| ($tokens[$stackPtr]['code'] === T_INTERFACE
				&& (bool)$this->checkInterface === false)
		) {
			return;
		}
		$openingBrace = $tokens[$stackPtr]['scope_opener'];
		$closeBracket = $stackPtr;
		$classLine = $tokens[$closeBracket]['line'];
		$braceLine = $tokens[$openingBrace]['line'];
		$lineDifference = ($braceLine - $classLine);
		if ($lineDifference > 0) {
			$phpcsFile->recordMetric($stackPtr, 'Class opening brace placement', 'new line');
			$error = 'Opening brace should be on the same line as the declaration';
			$fix = $phpcsFile->addFixableError($error, $openingBrace, 'BraceOnNewLine');
			if ($fix === true) {
				$phpcsFile->fixer->beginChangeset();
				$nameStart = $phpcsFile->findNext(T_WHITESPACE, ($stackPtr + 1), $openingBrace, true);
				$nameEnd = $phpcsFile->findNext(T_WHITESPACE, $nameStart, $openingBrace);
				$phpcsFile->fixer->replaceToken($nameEnd, ' {');
				$phpcsFile->fixer->replaceToken($openingBrace, '');
				$phpcsFile->fixer->endChangeset();
			}
		}
		$phpcsFile->recordMetric($stackPtr, 'Class opening brace placement', 'same line');
		$next = $phpcsFile->findNext(T_WHITESPACE, ($openingBrace + 1), null, true);
		if ($tokens[$next]['line'] === $tokens[$openingBrace]['line']) {
			if ($next === $tokens[$stackPtr]['scope_closer']) {
				// Ignore empty functions.
				return;
			}
			$error = 'Opening brace must be the last content on the line';
			$fix = $phpcsFile->addFixableError($error, $openingBrace, 'ContentAfterBrace');
			if ($fix === true) {
				$phpcsFile->fixer->addNewline($openingBrace);
			}
		}
		// Only continue checking if the opening brace looks good.
		if ($lineDifference > 0) {
			return;
		}
		if ($tokens[($closeBracket + 1)]['code'] !== T_WHITESPACE) {
			$length = 0;
		} else if ($tokens[($closeBracket + 1)]['content'] === "\t") {
			$length = '\t';
		} else {
			$length = strlen($tokens[($closeBracket + 1)]['content']);
		}
		if ($length !== 1) {
			$error = 'Expected 1 space after closing parenthesis; found %s';
			$data = array($length);
			$fix = $phpcsFile->addFixableError($error, $closeBracket, 'SpaceAfterBracket', $data);
			if ($fix === true) {
				if ($length === 0 || $length === '\t') {
					$phpcsFile->fixer->addContent($closeBracket, ' ');
				} else {
					$phpcsFile->fixer->replaceToken(($closeBracket + 1), ' ');
				}
			}
		}
	}
}
