---
title: "Automate Bank Statement Categorization Make.Com Claude 3.5 — Complete Step-by-Step Guide (2026)"
date: 2026-05-17T23:20:38+08:00
image: "images/blog/automate-bank-statement-categorization-make-com-claude-3-5.jpg"
author: "Automation Architect"
type: "post"
categories: ["Niche Workflows"]
tags: ["automate", "bank", "statement", "categorization", "Automation", "2026"]
description: "A complete, production-ready guide and downloadable blueprint for automate bank statement categorization make.com claude 3.5. Includes full workflow breakdown, field mappings, and common gotchas."
---

## The Problem

Manual bank statement reconciliation is the silent killer of productivity for small business owners and finance teams alike. Spending hours every month manually mapping vague transaction strings like "AMZN MKTP US*PR29" to "Office Supplies" or "Software Subscriptions" is not just tedious—it is prone to human error that can lead to expensive tax filing mistakes. Traditional rule-based categorization fails because vendor names change, transaction IDs are dynamic, and a single merchant can represent multiple expense categories.

## The Asset

To help you get started immediately, we have prepared a production-ready Make.com blueprint. This includes the pre-configured modules for PDF parsing, Anthropic Claude 3.5 Sonnet API integration, and database mapping.

**Download the Asset:** [/downloads/automate-bank-statement-categorization-make-com-claude-3-5-blueprint.json](/downloads/automate-bank-statement-categorization-make-com-claude-3-5-blueprint.json)

<!-- ADSENSE_INSERT_HERE -->

## Full Workflow Breakdown

Building a robust system to **automate bank statement categorization make.com claude 3.5** requires a multi-stage pipeline that handles unstructured data, transforms it into a machine-readable format, and applies high-level reasoning. 

As a professional automation architect, I recommend a 5-module architecture for maximum reliability and scalability.

### Module 1: The Trigger (Google Drive or Dropbox)
The workflow begins when a new PDF bank statement is uploaded to a specific folder. 
- **Trigger:** Google Drive > Watch Files in a Folder.
- **Output:** `{{1.fileId}}`, `{{1.fileName}}`, and `{{1.mimeType}}`.
- **Note:** Ensure your filter only allows `.pdf` or `.csv` files to avoid triggering the workflow on irrelevant documents.

### Module 2: The Document Parser (PDF.co or Make OCR)
Standard OCR is often insufficient for complex multi-column bank statements. I recommend using PDF.co’s "Document Parser" module because it can handle nested tables and different banking formats (Chase, Amex, HSBC) using templates.
- **Field Mapping:** Use `{{1.data}}` from the trigger.
- **Key Extraction:** We need to extract the Date, Description, and Amount for every row.

### Module 3: Data Aggregator & JSON Structuring
Raw OCR data is often messy. We use a "JSON > Create JSON" module to bundle the extracted rows into a single string. This minimizes the number of API calls to Claude, saving you significant costs on token usage.
- **Input:** `{{2.body.tables}}`
- **Logic:** Combine all transactions into an array: `[{"date": "01/01", "desc": "Starbucks", "amt": 5.50}, ...]`

### Module 4: The Brain (Anthropic Claude 3.5 Sonnet)
This is where the magic happens. We pass the aggregated JSON to Claude 3.5 Sonnet. Unlike GPT-4o, Claude 3.5 Sonnet shows superior performance in following strict JSON schemas and understanding the nuance of financial transactions without "hallucinating" categories.
- **Model:** `claude-3-5-sonnet-20240620`
- **System Prompt:** You are a senior accountant. Categorize these transactions into: [Software, Marketing, Travel, Rent, Meals]. Return ONLY valid JSON.
- **User Prompt:** `Categorize this data: {{3.jsonString}}`

### Module 5: The Destination (Airtable or Google Sheets)
Finally, we use an "Iterator" to split the JSON response from Claude back into individual records and save them to your financial database. If you are also managing marketing tasks, you might find that [Automated Linkedin Post Generation Using Make.Com And Claude 3.5 Sonnet — Complete Step-by-Step Guide (2026)](/blog/automated-linkedin-post-generation-using-make-com-and-claude-3-5-sonnet/) complements this by reporting your monthly savings or financial milestones automatically.
- **Field Mapping:** `{{5.category}}`, `{{5.amount}}`, `{{5.date}}`.

## Step-by-Step Configuration

### 1. Setting up the Trigger and File Retrieval
In Make.com, click the big "+" button to create a new scenario. Search for Google Drive and select "Watch Files in a Folder." Connect your account and select the folder where you drop your statements. Add a second module, "Google Drive > Download a File," and map the `File ID` from the first module: `{{1.fileId}}`.

### 2. High-Fidelity OCR Extraction
Bank statements are notoriously difficult to parse because they use "Z-patterns" and varying column widths. 
1. Add the **PDF.co** module and select "Parse a Document."
2. Create a template in PDF.co for your specific bank. This ensures the "Amount" column isn't confused with the "Balance" column.
3. In Make, set the input to the file content from the previous step.
4. Test this module to ensure you receive a clean array of transactions.

### 3. Prompt Engineering for Claude 3.5
This is the most critical step to **automate bank statement categorization make.com claude 3.5**.
- Add the **Anthropic** module. Select "Create a Message."
- **Model:** `claude-3-5-sonnet-20240620`.
- **Max Tokens:** 4096.
- **System Prompt:** 
  > "You are a specialized financial AI. You will receive a list of bank transactions. Your task is to categorize each transaction based on the merchant name. Use the following categories: [Operations, Payroll, Marketing, SaaS, Office, Travel]. 
  > Output format must be a raw JSON array of objects: [{"date": "string", "description": "string", "amount": "number", "category": "string", "confidence_score": "number"}]. 
  > Do not provide any conversational text before or after the JSON."

### 4. Handling the AI Response
The response from Claude will be a string. To turn it back into usable fields, add a "JSON > Parse JSON" module. Map the `{{4.content[].text}}` from the Claude module into the "JSON string" field. 

Now, add an "Iterator" module. This will allow Make to process each categorized transaction as a separate operation. Map the array resulting from the JSON Parse module into the "Array" field of the Iterator.

### 5. Data Storage and Synchronization
Finally, add an **Airtable > Create a Record** module. 
- **Base:** Select your Finance/Accounting base.
- **Table:** "Categorized Transactions."
- **Mappings:** 
  - Date: `{{6.date}}`
  - Merchant: `{{6.description}}`
  - Amount: `{{6.amount}}`
  - Category: `{{6.category}}`

Pro Tip: If you want to keep your schedule organized based on these financial updates, you can use the [Free Airtable To Google Calendar Sync Automation Blueprint: Download & Deploy in Minutes (2026)](/blog/airtable-to-google-calendar-sync-automation/) to automatically create "Review Sessions" on your calendar when high-value transactions or anomalies are detected.

## Common Gotchas

Through building dozens of these workflows in production, I’ve identified three major pain points you need to account for.

### 1. The 4k Token Context Limit
While Claude 3.5 has a massive context window, Make.com modules and standard API calls often have payload limits or timeouts. If you upload a 50-page PDF with 1,000 transactions, a single prompt might fail or time out. 
- **Solution:** Use a "Breakout" strategy. Use a "Basic Aggregator" in Make to bundle transactions in groups of 50. Process each group through Claude separately. This ensures high accuracy and prevents API timeouts.

### 2. Hallucinated Categorization
Sometimes Claude might see "Apple.com/Bill" and categorize it as "Office Supplies" one day and "SaaS" the next. 
- **Solution:** Provide a "Reference Dictionary" in the system prompt. Include a few examples of your specific vendors and your preferred categories. "Example: Apple.com/Bill is always SaaS. Shell Oil is always Travel." This drastically increases consistency.

### 3. Currency and Number Formatting
Banks in different regions use different decimal separators (commas vs. periods). OCR often reads "$1,200.00" as "1.200.00" or just "1200". 
- **Solution:** Use Make's built-in `parseNumber()` and `replace()` functions before sending data to Claude. Ensure the amount is a clean float. For example: `{{parseNumber(replace(2.amount; ","; ""))}}`. Claude is smart, but giving it clean data reduces the chance of mathematical errors during the categorization phase.

## Technical Nuance: The Role of Confidence Scores
In the Claude prompt mentioned earlier, I included a `confidence_score`. This is a professional-grade technique. 
- If Claude returns a `confidence_score < 0.8`, use a "Filter" in Make to route that specific record to a "Manual Review" table in Airtable. 
- If the score is `> 0.8`, mark it as "Auto-Approved."
This "Human-in-the-loop" (HITL) design is what separates a hobbyist script from a production-ready financial automation.

## Conclusion

To **automate bank statement categorization make.com claude 3.5** is to reclaim dozens of hours of high-value time every month. By leveraging the reasoning power of Claude 3.5 Sonnet and the orchestration capabilities of Make.com, you move from manual data entry to strategic financial oversight. Remember to start with the provided blueprint, handle your OCR parsing with precision, and always implement a confidence-score filter to ensure your books remain 100% accurate.

By following this guide, you are not just building a workflow; you are building a scalable financial operations engine that will serve your business well into 2026 and beyond.