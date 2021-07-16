module.exports = {
    // login page
    LOGIN_401: "You have an incorrect username or password.",
    LOGIN_MISSING_PASSWORD: "You must enter a password.",
    LOGIN_INVALID_FIELDS: "You must provide all of your login information.",
    LOGIN_MISSING_EMAIL: "You must enter an email address.",
    LOGIN_NOT_AN_EMAIL: "Email address needs to be in the correct format e.g. xyz@test.com",
    LOGIN_SHORT_PASSWORD: "Your password must be at least 6 characters long.",
    LOGIN_PASSWORDS_DO_NOT_MATCH: "Your passwords do not match.",
    SOMETHING_WENT_WRONG: (helpEmail) => `Oops, something went wrong on our end. Please try again in a few minutes or contact us at ${helpEmail} if the problem persists.`,
    LOGIN_MISSING_NEW_PASSWORD: "You must enter a new password.",
    LOGIN_PASSWORDS_MUST_MATCH: "Your passwords must match.",
    LOGIN_PASSWORD_INVALID: "Your new password must meet the security criteria.",
    LOGIN_PASSWORD_RESET_EMAIL_SEND: "If an account with the address you specified exists you will receive an email with a password reset link.",
    LOGIN_PASSWORD_CHANGED: "You successfully changed your password.",
    LOGIN_TOKEN_EXPIRED: (resetPasswordLink) => `The password reset link you used is no longer valid. Please request another link here: ${resetPasswordLink}`,
    SURVEY_SAVE_SUCCESS: "Survey successfully saved.",
    SURVEY_CONFIRM_PUBLISH: "You have published this survey. This will allow responses to be collected. Are you sure you want to publish this survey?",
    SURVEY_CONFIRM_CLOSE: "You have closed this survey. This will no longer allow any responses to be collected. Are you sure you want to close this survey?",
    SURVEY_CONFIRM_DELETE: "DELETE OR DEATH!!! (This needs copy)",
    SURVEY_CONFIRM_DELETE_PAGE_1: "Deleting a page also deletes the questions and response options it contains.",
    SURVEY_CONFIRM_DELETE_PAGE_2: "To preserve the questions, choose \"Merge page up\" from the page options.",
    SURVEY_CONFIRM_MERGE_PAGE: "You will lose me forever, but my questions will remain... (This needs copy)",
    SURVEY_SAVE_SUCCESS_PUBLISH: "Survey successfully published.",
    SURVEY_SAVE_SUCCESS_CLOSE: "Survey successfully closed.",
    SURVEY_SAVE_SUCCESS_DELETE: "Survey successfully deleted.",
    SURVEY_RESULTS_CLEAR_SUCCESS: "Results successfully cleared.",
    SURVEY_RESULTS_CLEAR_CONFIRM: "This will permanently delete all responses to this survey. Are you sure you wish to clear all responses?",
    SURVEY_RESULTS_FREEZE_SUCCESS: "Response edits successfully frozen.",
    SURVEY_RESULTS_UNFREEZE_SUCCESS: "Response edits successfully unfrozen.",
    NOT_IMPLEMENTED: "This feature is not yet implemented. Check back soon!",
}
