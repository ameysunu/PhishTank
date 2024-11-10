﻿using DotnetGeminiSDK.Client.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace PhishTankGCPRun
{
    public class GeminiProcessor
    {
        private readonly IGeminiClient _geminiClient;

        public GeminiProcessor(IGeminiClient geminiClient)
        {
            _geminiClient = geminiClient;
        }

        public async Task<string> GeminiRun(string prompt)
        {
            var response = await _geminiClient.TextPrompt(prompt);

            if(response != null)
            {
                return response.Candidates[0].Content.Parts[0].Text;
            }

            return "";
            
        }
    }
}