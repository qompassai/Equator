var aiColor = "#c51a4a";
Blockly.Blocks['import_ai'] = {
    init: function () {
        this.appendDummyInput()
            .appendField("import ai");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(aiColor);
    }
};
Blockly.Blocks['ai_init'] = {
    init: function () {
        this.appendDummyInput()
            .appendField(new Blockly.FieldVariable("chatbot"), "chatbot")
            .appendField(" = ai.Assistant(");
        this.appendValueInput("parameters")
            .setCheck(null);
        this.appendDummyInput()
            .appendField(")");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(aiColor);
    }
};
Blockly.Blocks['ai_setup'] = {
    init: function () {
        this.appendDummyInput()
            .appendField("await ")
            .appendField(new Blockly.FieldVariable("chatbot"), "chatbot")
            .appendField(".setup()");
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(aiColor);
    }
};
Blockly.Blocks['ai_add_prompt'] = {
    init: function () {
        this.appendDummyInput()
            .appendField("await ")
            .appendField(new Blockly.FieldVariable("chatbot"), "chatbot")
            .appendField(".add_prompt(");
        this.appendValueInput("parameters")
            .setCheck(null);
        this.appendDummyInput()
            .appendField(")");
        this.setInputsInline(true);
        this.setPreviousStatement(true, null);
        this.setNextStatement(true, null);
        this.setColour(aiColor);
    }
};
Blockly.Blocks['ai_ask'] = {
    init: function () {
        this.appendDummyInput()
            .appendField("await ")
            .appendField(new Blockly.FieldVariable("chatbot"), "chatbot")
            .appendField(".ask(");
        this.appendValueInput("parameters")
            .setCheck(null);
        this.appendDummyInput()
            .appendField(")");
        this.setInputsInline(true);
        this.setOutput(true, null);
        this.setColour(aiColor);
    }
};
Blockly.Blocks['ai_model'] = {
    init: function () {
        this.appendDummyInput()
            .appendField("model=")
            .appendField(new Blockly.FieldDropdown([['"red_pajama"', '"red_pajama"'], ['"llama_v2"', '"llama_v2"']]), "model");
        this.setInputsInline(true);
        this.setOutput(true, null);
        this.setColour(aiColor);
    }
};
