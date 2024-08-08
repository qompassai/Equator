from pyscript import window, document
from pyodide.ffi import create_proxy

class Assistant:
    def __init__(self, model="red_pajama"):
        self.chat = window.webllm.ChatModule.new()
        self.models = {
            "red_pajama" : "RedPajama-INCITE-Chat-3B-v1-q4f32_1",
            "llama_v2" : "Llama-2-7b-chat-hf-q4f32_1"
        }
        self.model = model

    def _update_progress(self, report, indicator):
        indicator.value = report.progress * 100

    async def setup(self):
        # Create Dialog
        loading = document.createElement("dialog")

        # Create Dialog Title
        loading_title = document.createElement("h3")
        loading_title.textContent = "Loading AI Model..."

        # Create Progress Indicator
        loading_progress = document.createElement("progress")
        loading_progress.max = 100

        # Add Dialog Title & Progress Indicator
        loading.appendChild(loading_title)
        loading.appendChild(loading_progress)

        # Add Dialog to Document
        document.body.appendChild(loading)

        # Show Loading Dialog
        loading.showModal()

        # Update Progress Indicator Value
        self.chat.setInitProgressCallback(create_proxy(lambda report: self._update_progress(report, loading_progress)))

        # Load AI Model
        await self.chat.reload(self.models[self.model])

        # Close Loading Dialog
        loading.close()

    async def ask(self, question):
        return await self.chat.generate(question)

    async def add_prompt(self, prompt):
        await self.chat.generate(prompt)