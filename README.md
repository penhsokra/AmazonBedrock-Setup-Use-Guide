# 🚀 Claude Code CLI - ក្រុមហ៊ុន (Enterprise Guide)

ស្វាគមន៍មកកាន់ការប្រើប្រាស់ AI Assistant សម្រាប់ការសរសេរ Code! យើងប្រើប្រាស់ **Amazon Bedrock** ដើម្បីធានាថា Code របស់ក្រុមហ៊ុនមិនត្រូវបានបញ្ចេញទៅក្រៅ និងមានសុវត្ថិភាពបំផុត។

## 🛠️ ការរៀបចំដំបូង (First-time Setup)

1. **ដំឡើង AWS CLI:** ប្រាកដថាអ្នកមាន [AWS CLI](https://aws.amazon.com/cli/) រួចរាល់។
2. window install claude cli : irm https://claude.ai/install.ps1 | iex
3. **ដំឡើង Node.js:** ត្រូវការ Version 18 ឡើងទៅ។
4. **Run Setup Script:** - ទាញយក `setup-claude-enterprise.ps1`។
   - Right-click រួចជ្រើសរើស **"Run with PowerShell"**។
   - បញ្ចូលលេខក្រុមរបស់អ្នក (ឧទាហរណ៍: `05`)។

## 🔑 របៀប Login (រាល់ព្រឹក)

មុនពេលចាប់ផ្ដើមប្រើ Claude អ្នកត្រូវ Login ចូល AWS ជាមុនសិន៖
```powershell
aws sso login
