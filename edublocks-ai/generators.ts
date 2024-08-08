Blockly.Python['import_ai'] = function() {
    var code = 'import ai\n';
    return code;
};

Blockly.Python['ai_init'] = function(block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = `${chatbot} = ai.Assistant(${parameters})\n`;
    return code;
};

Blockly.Python['ai_setup'] = function(block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var code = `await ${chatbot}.setup()\n`;
    return code;
};

Blockly.Python['ai_add_prompt'] = function(block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = `await ${chatbot}.add_prompt(${parameters})\n`;
    return code;
};  

Blockly.Python['ai_ask'] = function(block) {
    var chatbot = Blockly.Python.nameDB_.getName(block.getFieldValue('chatbot'), Blockly.VARIABLE_CATEGORY_NAME);
    var parameters = Blockly.Python.valueToCode(block, 'parameters', 0);
    var code = `await ${chatbot}.ask(${parameters})`;
    return [code, 0];
};  

Blockly.Python['ai_model'] = function(block) {
    var model = block.getFieldValue('model');
    var code = `model=${model}`;
    return [code, 0];
};  