Blockly.Python['import_ai'] = function () {
    var code = 'import ai\n';
    return code;
};
Blockly.Python['ai_init'] = function (block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = "".concat(chatbot, " = ai.Assistant(").concat(parameters, ")\n");
    return code;
};
Blockly.Python['ai_setup'] = function (block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var code = "await ".concat(chatbot, ".setup()\n");
    return code;
};
Blockly.Python['ai_add_prompt'] = function (block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = "await ".concat(chatbot, ".add_prompt(").concat(parameters, ")\n");
    return code;
};
Blockly.Python['ai_ask'] = function (block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = "await ".concat(chatbot, ".ask(").concat(parameters, ")");
    return [code, 0];
};
Blockly.Python['ai_model'] = function (block) {
    var model = block.getFieldValue('model');
    var code = "model=".concat(model);
    return [code, 0];
};
