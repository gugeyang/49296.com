---
title: "Automated Linkedin Post Generation Using Make.Com And Claude 3.5 Sonnet — Complete Step-by-Step Guide (2026)"
date: 2026-05-16T14:52:08+08:00
image: "images/blog/automated-linkedin-post-generation-using-make-com-and-claude-3-5-sonnet.jpg"
author: "Automation Architect"
type: "post"
categories: ["Niche Workflows"]
tags: ["automated", "linkedin", "post", "generation", "Automation", "2026"]
description: "A complete, production-ready guide and downloadable blueprint for automated linkedin post generation using make.com and claude 3.5 sonnet. Includes full workflow breakdown, field mappings, and common gotchas."
---

## The Problem

Manual content creation for professional networks is the single biggest bottleneck for modern B2B thought leaders and marketing teams. The process of researching a topic, drafting a post that matches your brand voice, formatting it for the LinkedIn algorithm, and manually logging into the platform to publish leads to "content fatigue" and inconsistent posting schedules. This inconsistency kills organic reach, as the LinkedIn algorithm prioritizes creators who maintain a steady cadence of high-quality, high-context engagement.

## The Asset

To help you skip the technical hurdles of API configuration and prompt engineering, we have prepared a production-ready Make.com blueprint. This file includes the pre-configured modules for Anthropic’s Claude 3.5 Sonnet and the LinkedIn UGC (User Generated Content) API.

**Download the Blueprint:** [/downloads/automated-linkedin-post-generation-using-make-com-and-claude-3-5-sonnet-blueprint.json](/downloads/automated-linkedin-post-generation-using-make-com-and-claude-3-5-sonnet-blueprint.json)

<!-- ADSENSE_INSERT_HERE -->

## Full Workflow Breakdown

This architecture utilizes a multi-step logic flow to ensure that the content generated is not just "AI filler" but high-value professional insight. We leverage Claude 3.5 Sonnet specifically because of its superior reasoning capabilities and its ability to follow complex brand style guidelines compared to other LLMs.

### Module 1: The Trigger (Airtable or Google Sheets)
The workflow begins when a new record is created in an Airtable base. This record contains the "Seed Topic," "Key Takeaways," and "Target Audience." Using a structured database as your source ensures that your automated posts are grounded in real data or specific ideas you’ve curated.
*   **Field Mapping:** `{{1.Topic}}`, `{{1.Target_Audience}}`, `{{1.Tone_Profile}}`
*   **Pro Tip:** If you are managing a complex content calendar, you might also want to look into a [Free Airtable To Google Calendar Sync Automation Blueprint: Download & Deploy in Minutes (2026)](/blog/airtable-to-google-calendar-sync-automation/) to keep your publishing dates synchronized across your organization.

### Module 2: Claude 3.5 Sonnet (The Brain)
We use the Anthropic "Create a Message" module. Claude 3.5 Sonnet is preferred here because it handles "Style Transfer" exceptionally well. In the System Prompt, we define the persona of a senior executive or industry expert.
*   **System Prompt:** "You are a professional LinkedIn Ghostwriter. Write a post based on the following input. Use short, punchy sentences. Include 3 relevant hashtags. Ensure the first line is a hook."
*   **User Content:** `Generate a LinkedIn post about {{1.Topic}} for an audience of {{1.Target_Audience}}. Tone should be {{1.Tone_Profile}}.`
*   **Field Mapping:** Output is captured as `{{2.content[1].text}}`.

### Module 3: Text Formatter & Cleaner
AI-generated text often includes markdown symbols (like `**` for bold) that LinkedIn does not render natively. We use a "Text Parser" or "Set Variable" module to strip unwanted markdown or replace it with Unicode bold/italic characters if a stylized look is desired.
*   **Field Mapping:** `replace({{2.content[1].text}}; "**"; "")`

### Module 4: LinkedIn (The Distribution)
The final module is the LinkedIn "Create a Post" action. We use the `urn:li:person:XXXX` or `urn:li:organization:XXXX` identifier to route the content to the correct profile or company page.
*   **Content Field:** `{{3.formatted_text}}`
*   **Visibility:** `public`

## Step-by-Step Configuration

Building this in Make.com requires precise configuration of the API connections. Follow these steps to ensure a 100% success rate during your first run.

### 1. Setting up the Data Source
Create an Airtable base with four columns: `Topic`, `Context`, `Status` (Dropdown: Draft, Approved, Published), and `Post_Date`. Configure the Make.com Airtable module to "Watch Records" where the `Status` is equal to "Approved." This adds a "Human-in-the-loop" step, ensuring you review the ideas before Claude generates the final draft.

### 2. Connecting Claude 3.5 Sonnet
You will need an Anthropic API Key. In Make, select the Anthropic module and choose the "Claude 3.5 Sonnet" model. Set the `Max Tokens` to 1024 and the `Temperature` to 0.7. A temperature of 0.7 provides the perfect balance between professional stability and creative "flair." 

If you've previously experimented with other models, you might notice that [Chatgpt Api Google Sheets Automation — Production-Ready Workflow + Free JSON Download](/blog/chatgpt-api-google-sheets-automation/) works well for short-form data processing, but for the nuanced, long-form professional tone required by LinkedIn, Claude 3.5 Sonnet is the current industry leader as of 2026.

### 3. Mastering the LinkedIn API Connection
When connecting LinkedIn to Make, ensure you select the following scopes in the OAuth popup:
*   `w_member_social` (to post to your personal profile)
*   `w_organization_social` (if posting to a company page)
*   `r_liteprofile` (to fetch your URN)

In the "Content" field of the LinkedIn module, map the output from the Claude module. If you want to include an image, you must first use a "LinkedIn: Upload an Image" module, which returns a `media_asset` ID, and then map that ID into the "Create a Post" module.

## Deep Dive: Prompt Engineering for LinkedIn

To make your **automated linkedin post generation using make.com and claude 3.5 sonnet** truly effective, the prompt is your most valuable intellectual property. Below is a production-level prompt structure you can copy into your Make module:

```text
Role: Senior LinkedIn Content Strategist
Objective: Convert the provided [Topic] into a viral-style LinkedIn post.
Format:
1. Hook: A one-sentence contrarian statement or a massive result.
2. The "Why": 3 bullet points explaining the significance.
3. The "How": A brief instructional paragraph.
4. Call to Action: A question to drive comments.
Constraints: No emojis in the hook. Max 3 hashtags. Use professional but conversational language.
Input: {{1.Context}}
```

By providing Claude with a structural framework, you eliminate the "robotic" feel that plagues most AI-generated content.

## Common Gotchas

Even with the best tools, API-driven workflows can encounter friction. Here are the three most common issues we see in production environments:

### 1. The LinkedIn URN Mismatch
The LinkedIn API does not use your username; it uses a Unique Resource Name (URN). If your module fails with a "400 Bad Request," check that your "Author" field is formatted exactly as `urn:li:person:YOUR_ID_HERE`. You can find your ID by using the "Get My Profile" module in Make before running the post module.

### 2. Rate Limiting on Anthropic
While Claude 3.5 Sonnet is powerful, new Anthropic accounts often have low "Tokens Per Minute" (TPM) limits. If you attempt to generate 50 posts at once, the workflow will error out. To solve this, add a "Sleep" module (found under the Tools category) between iterations, or set the "Maximum number of cycles" in the Make scenario settings to a lower number.

### 3. Unicode and Special Characters
LinkedIn's API is sensitive to certain JSON-breaking characters. If your AI output contains unescaped quotes or specific mathematical symbols, the API call might fail. It is best practice to use the `stripHTML()` and `escapeJSON()` functions within Make's mapping panel to sanitize the text: `{{escapeJSON(2.content)}}`.

## Advanced Optimization: The Content Feedback Loop

Once your **automated linkedin post generation using make.com and claude 3.5 sonnet** workflow is stable, you can take it a step further by creating a feedback loop. By using a "LinkedIn: List Posts" module, you can pull engagement metrics (likes, comments, shares) back into your Airtable base.

Imagine a scenario where Claude analyzes which of your previous posts performed best and adjusts the "Tone" or "Hook" of future posts based on that data. This creates a self-optimizing content engine that matures over time. For those looking to scale this across multiple platforms, understanding [How to Set Up Chatgpt Api To Google Sheets Automation Without Code (2026 Guide)](/blog/chatgpt-api-to-google-sheets-automation/) provides a great foundation for handling large-scale data logging which can then be fed back into your Claude prompts.

## Conclusion

The era of manual content distribution is over. By combining the logical orchestration of Make.com with the high-reasoning output of Claude 3.5 Sonnet, you can build a LinkedIn presence that is both consistent and highly sophisticated. This workflow doesn't just save time; it ensures that your professional brand remains active even when you are focused on deep work or high-level strategy. Download the blueprint provided above, map your API keys, and start scaling your professional reach today.