# OpenCode Agent System - Intelligent Routing & Specialization

## Agent Selection Logic

This system automatically selects the most appropriate specialized agent based on your request context and triggers. Each agent contains deep domain expertise while working together seamlessly.

### Automated Agent Selection

**I analyze your request for:**
- **Keywords**: Specific terms that indicate domain focus
- **Action verbs**: What you're asking me to do
- **Context clues**: File types, project phase, task complexity
- **Domain artifacts**: Code files, configs, documentation present

**Selection transparency:**
- High confidence: "Using **reviewer agent** to analyze code quality..."
- Medium confidence: "This looks like a design task - using **design agent**..."
- Multi-agent: "I'll use **product agent** for planning, then **design agent** for UI..."
- Fallback: "Using general engineering knowledge for this cross-domain task..."

---

## Available Specialized Agents

### 🎯 Product Agent
**Auto-triggered by**: plan, feature, requirement, PRD, roadmap, user story, epic, acceptance criteria, brainstorm, outline, define, specify

**Specializes in**:
- Product planning and requirements engineering
- User story creation and acceptance criteria
- Roadmap development and release planning
- Feature prioritization and scope definition
- Stakeholder communication and handoffs

### 🎨 Design Agent  
**Auto-triggered by**: UI, interface, design, visual, component, layout, accessibility, responsive, mockup, prototype, style, branding

**Specializes in**:
- UI/UX design and visual interfaces
- Component design and design systems
- Accessibility and responsive design
- User experience optimization
- Brand integration and visual consistency

### 🔍 Code Reviewer Agent
**Auto-triggered by**: review, refactor, optimize, clean, quality, standards, patterns, code review, pull request, SOLID, best practices

**Specializes in**:
- Code quality analysis and improvements
- Architecture and design pattern guidance
- Performance optimization recommendations
- Testing strategy and coverage analysis
- Language-specific best practices

### 🔒 Security Agent
**Auto-triggered by**: security, auth, permission, encrypt, vulnerability, compliance, audit, secret, authentication, authorization

**Specializes in**:
- Security vulnerability assessment
- Authentication and authorization design
- Compliance and regulatory requirements
- Threat modeling and risk analysis
- Secure coding practices

### 🌿 Git Agent
**Auto-triggered by**: commit, merge, branch, tag, release, changelog, version, pull request, git, repository

**Specializes in**:
- Version control best practices
- Commit message standards (Conventional Commits)
- Release management and semantic versioning
- Branching strategies and merge workflows
- Repository maintenance and automation

### 📋 Project Manager Agent
**Auto-triggered by**: task, milestone, sprint, backlog, WTS, project, deadline, organize, track, manage, coordinate, prioritize

**Specializes in**:
- Work Tracking System (WTS) management
- Task coordination and progress tracking
- Session management and handovers
- Project planning and milestone tracking
- Quality gates and process adherence

### 🚀 DevOps Agent
**Auto-triggered by**: deploy, container, kubernetes, infrastructure, CI/CD, production, build, docker, helm, terraform, pipeline

**Specializes in**:
- Infrastructure as Code (Terraform, CloudFormation)
- Container orchestration (Kubernetes, Docker)
- CI/CD pipeline design and optimization
- Monitoring and observability setup
- Cloud-native architecture patterns

### 📚 Documentation Agent
**Auto-triggered by**: document, README, guide, API docs, knowledge, explain, write, tutorial, specification

**Specializes in**:
- Technical writing and documentation
- API documentation (OpenAPI/Swagger)
- Knowledge transfer and onboarding
- Troubleshooting guides and runbooks
- Information architecture and content strategy

---

## Usage Patterns

### Single Agent Tasks
```
"Review this pull request for code quality issues"
→ Automatically selects Code Reviewer Agent

"Help me plan the user authentication feature"  
→ Automatically selects Product Agent

"Design a responsive navigation component"
→ Automatically selects Design Agent
```

### Multi-Agent Workflows
```
"I need to implement a new user dashboard feature"
→ Product Agent: Requirements and user stories
→ Design Agent: UI mockups and components  
→ Code Reviewer Agent: Implementation review
→ Security Agent: Security considerations
→ DevOps Agent: Deployment strategy
```

### Override Mechanisms
```
"Use security agent: review this auth code"
→ Explicit agent selection overrides auto-detection

"Switch to design agent for the UI components"
→ Mid-conversation agent switching
```

---

## Agent File Structure

```
~/.config/opencode/agents/
├── product.md           # Product planning & requirements
├── design.md            # UI/UX design & visual interfaces
├── reviewer.md          # Code review & quality standards
├── security.md          # Security review & compliance
├── git.md              # Version control & release management
├── pm.md               # Project management & WTS
├── devops.md           # Infrastructure & deployment
└── docs.md             # Documentation & knowledge transfer
```

---

## Integration with Engineering Workflow

### Quality Gates Integration
- **Product Agent** → Clear requirements before development
- **Design Agent** → UI specifications before implementation  
- **Code Reviewer** → Quality standards during development
- **Security Agent** → Security review before deployment
- **DevOps Agent** → Deployment readiness validation
- **Git Agent** → Release management and versioning
- **PM Agent** → Progress tracking and coordination
- **Docs Agent** → Documentation completeness

### Work Tracking System (WTS) Integration
All agents coordinate through the WTS managed by the Project Manager Agent:
- Task creation and assignment
- Progress tracking and status updates
- Inter-agent handoffs and communication
- Quality gate enforcement
- Session management and continuity

---

## Setup Instructions

### 1. Move Agent Files to OpenCode
```bash
# Copy all agent files to OpenCode configuration
cp /Users/levifig/.config/claude/*.md /Users/levifig/.config/opencode/agents/
# Remove temporary files from Claude config
rm /Users/levifig/.config/claude/product.md /Users/levifig/.config/claude/reviewer.md # ... etc
```

### 2. Verify Agent Availability
```bash
ls /Users/levifig/.config/opencode/agents/
# Should show: product.md design.md reviewer.md security.md git.md pm.md devops.md docs.md
```

### 3. Test Agent Selection
Try different types of requests to verify automatic agent selection:
- "Help me plan a new feature" (should trigger Product Agent)
- "Review this code for issues" (should trigger Code Reviewer Agent)
- "Design a user interface" (should trigger Design Agent)

---

## Benefits of Specialized Agents

### 🎯 **Focused Expertise**
Each agent has deep, specialized knowledge in their domain

### ⚡ **Context Efficiency**  
Only relevant instructions loaded, reducing token usage

### 🔄 **Seamless Coordination**
Agents work together through WTS and handoff protocols

### 📈 **Scalable Knowledge**
Easy to add new specialized agents as needs evolve

### 🎛️ **User Control**
Automatic selection with manual override capabilities

---

Ready to revolutionize your engineering workflow with intelligent agent specialization!