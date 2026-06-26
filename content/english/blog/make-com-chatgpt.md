---
title: "Make.com ChatGPT — Production-Ready Workflow + Free JSON Download"
date: 2026-06-26T14:28:25+08:00
image: "images/blog/make-com-chatgpt.jpg"
author: "Automation Architect"
type: "post"
categories: ["Templates & Blueprints"]
tags: ["Make.com", "ChatGPT", "Automation", "2026"]
description: "Learn to build a fail-proof Make.com ChatGPT workflow for automated content processing, handle GPT-5 rate limits, and download the exact JSON blueprint I use for clients."
---

Three months ago, I was sitting in a hotel lobby in Austin, staring at a Slack channel lighting up like a Christmas tree. A marketing agency client of mine had a "critical" workflow built on Make.com that ingested 500 blog transcripts a week and used ChatGPT to generate social snippets. It had been running for months without a hitch. Then, at 2:14 AM, OpenAI bumped their API response times, Make.com’s default timeout kicked in, and the scenario went into a death spiral. 

By the time I woke up, the client had burned through 40,000 Make credits in four hours because of an "Intermediate Error" that triggered an aggressive, unmanaged retry loop. Their Airtable was a mess of duplicate records and half-finished sentences. This wasn't a "scaling issue"; it was an architecture issue. I spent the next six hours rebuilding their entire logic to handle the realities of 2026-era API volatility.

If you are just dragging a "Chat Completions" module into a canvas and hoping for the best, you are building a ticking time bomb. This is how I build these now to ensure they don't break when the API gets sluggish or the credit limit hits a wall.

## The Blueprint

I’ve packaged the exact scenario structure I use for high-volume content processing. It includes the error-handling routes and the JSON parsing logic that most people skip.

[Download the Make.com ChatGPT Blueprint JSON](/downloads/make-com-chatgpt-blueprint.json)

<!-- ADSENSE_INSERT_HERE -->

## Full Workflow Breakdown

When we talk about a "Make.com ChatGPT" build, we aren't just talking about two modules. A production-grade scenario requires at least five distinct stages to be reliable.

### 1. The Trigger: Airtable "Watch Records"
I almost always use Airtable as the "brain" for these builds. On a Team plan ($20/mo per user), you get 50,000 records per base, which is plenty for most mid-sized operations. I set the trigger to watch a specific view called "Ready for AI." 
*   **Field Mapping:** I pull the `{{1.RawText}}` and a `{{1.RecordID}}`. 
*   **Pro Tip:** Never trigger on "New Record." Always trigger on "Modified Time" or a specific status checkbox to avoid firing the automation before you've finished typing. This is a lesson I learned after a client accidentally sent 50 "Draft" emails to their list because they hit 'Enter' too early. If you're managing complex dates, you might want to check out my guide on [Free Airtable To Google Calendar Sync Automation Blueprint: Download & Deploy in Minutes (2026)](/blog/airtable-to-google-calendar-sync-automation/) to see how I handle timing triggers.

### 2. The Processor: OpenAI "Chat Completions"
This is the heavy lifter. In 2026, we’re primarily using GPT-5 models. 
*   **Model:** `gpt-5-nano` (for speed/cost) or `gpt-5.2-pro` (for complex logic). 
*   **System Prompt:** This is where the magic happens. I don't just say "Summarize this." I use structured output prompts: "You are a professional editor. Return ONLY a valid JSON object with the keys 'summary', 'hashtags', and 'sentiment'."
*   **Cost Check:** GPT-5 nano is roughly $0.0004 per 1,000 output tokens. If you’re running 1,000 runs a month, your OpenAI bill is pennies, but your Make.com credit usage is what you need to watch.

### 3. The Cleaner: JSON Parser
OpenAI is notorious for wrapping its responses in markdown backticks like ```json { ... } ```. If you map that directly to another app, the app will crash or display the backticks. I insert a "JSON Parser" module here. I map the output using a simple regex or a string replacement function: `replace({{3.message.content}}; /```json|```/g; )`.

### 4. The Destination: Notion or Slack
For this blueprint, we are using Notion. On the Plus plan ($10/mo), you have unlimited blocks. I map the parsed JSON fields:
*   `Summary` -> `{{4.summary}}`
*   `Status` -> "Completed"
*   `AI Cost` -> `{{(3.usage.total_tokens / 1000) * 0.0004}}` (Yes, I track the cost per row in a decimal field).

## Step-by-Step Configuration

To get this running, follow these exact UI steps in Make.com:

1.  **Create a New Scenario:** Click the big plus button. Don't use a template; start from scratch.
2.  **OpenAI Connection:** You’ll need your API key from the OpenAI dashboard. In 2026, ensure you are at least "Tier 3" in your usage limits if you plan to process more than 5,000 requests per minute. New accounts start at the Free tier with a $100/month cap.
3.  **Module Settings:** Inside the "Create a Chat Completion" module, set the **Max Tokens** to 1,000 for standard summaries. Leaving this empty is a recipe for a "Token Limit Exceeded" error if the model starts hallucinating a never-ending list.
4.  **The Error Handler:** Right-click the OpenAI module and select **"Add error handler."** Choose the **"Sleep"** module. Set it to 60 seconds, followed by a "Resume" or "Rollback" directive. This is the single most important step. When you hit a 429 "Too Many Requests" error, this handler pauses the execution instead of failing the whole scenario.
5.  **Credit Management:** Since Make.com shifted to the "Credits" system in August 2025, a single AI module run can consume between 1 and 5 credits depending on the complexity of the data mapping. On the $9 Core plan, you get 10,000 credits. Monitor this closely in the first week.

If you are building this for content marketing, you might also want to see how I structured a similar logic for [Automated Linkedin Post Generation Using Make.Com And Claude 3.5 Sonnet — Complete Step-by-Step Guide (2026)](/blog/automated-linkedin-post-generation-using-make-com-and-claude-3-5-sonnet/). The principles are identical, but the prompt engineering varies for social platforms.

## Common Gotchas

### 1. The "429: Too Many Requests" Wall
This isn't a Make.com bug; it's an OpenAI quota. Even if you have the money, OpenAI limits how many "Tokens Per Minute" (TPM) you can pump through. If you are watching a database of 1,000 rows and Make tries to process them all at once, you will hit this wall. 
*   **Fix:** In the Airtable trigger, set the "Limit" to 10 or 20 records per run. Schedule the scenario to run every 15 minutes instead of "Immediately." This spaces out the API calls.

### 2. The Expired Token / Disconnected Account
Make.com's connections can occasionally "soft-fail." I’ve seen scenarios where the OpenAI module says it's connected, but it returns a 401 error because the API key was rotated or the usage limit was hit on the OpenAI side.
*   **Fix:** Set up a separate "Watchdog" scenario. This is a simple 2-module scenario that runs once a day, sends a tiny "Hello" prompt to OpenAI, and Slacks me if it fails. It costs 2 credits a day and saves me from discovering a broken scenario three days late.

### 3. JSON Hallucinations
You ask for JSON, but ChatGPT gives you a conversational intro: "Sure, here is your JSON: { ... }". This will break your JSON Parser module every single time.
*   **Fix:** Use the "Developer Message" (formerly System Message) to strictly enforce the format. But also, add a "Filter" between the OpenAI module and the JSON Parser. The filter condition should be: `Chat Completions: Message Content` CONTAINS `{`. This prevents the parser from trying to process plain text.

## My Take

People often ask me, "Marcus, should I use Zapier or Make for ChatGPT?" 

Here is the truth: Zapier is fine if you are doing one-step tasks, like "When I get an email, summarize it." But Zapier’s "Professional" plan starts at $19.99 for only 750 tasks. In a production environment, 750 tasks disappear in a heartbeat. 

I use Make.com because the credit system is more forgiving for complex branching logic. More importantly, Make allows for **Error Handling Routes**. In Zapier, if a step fails, the whole thing stops. In Make, I can tell the scenario, "If OpenAI is down, wait 5 minutes and try again, but if it fails a second time, just save the raw data to a 'Failed' folder in Google Drive and keep moving." 

If you're doing high-stakes data processing—like the kind I described in my article on how to [Automate Bank Statement Categorization Make.Com Claude 3.5 — Complete Step-by-Step Guide (2026)](/blog/automate-bank-statement-categorization-make-com-claude-3-5/)—you cannot afford a "hard stop" failure. You need the granular control that Make provides.

One thing I wish someone had told me before I built my first 50 scenarios: **Always store the Prompt and the Response in a log.** When a client asks why the AI wrote something weird, you need to be able to show them the exact prompt you sent. I usually create a "Log" tab in Airtable just for this. It’s saved my skin in at least a dozen meetings.

The "Make.com ChatGPT" stack is the most powerful tool in the no-code kit right now. Just remember that you're building on top of two different platforms' limits. Respect the credits, handle the errors, and for the love of everything, don't forget to set a Max Token limit. 

Build your first run, watch the logs, and tweak your "Sleep" timers until the 2 AM errors stop appearing in your inbox. That is the difference between an amateur build and a production-ready automation.