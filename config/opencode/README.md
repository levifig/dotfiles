# OpenCode Intelligent Agent System

A revolutionary multi-agent system that automatically selects specialized AI assistants based on your engineering tasks. Transform your development workflow with domain experts that work together seamlessly.

## 🎯 Overview

This system provides 8 specialized agents, each with deep expertise in their domain, that automatically activate based on your request context. No more generic responses - get expert-level guidance tailored to your specific engineering needs.

### Key Benefits

- **🧠 Intelligent Routing**: Automatic agent selection based on context analysis
- **⚡ Focused Expertise**: Deep domain knowledge for each engineering discipline
- **🔄 Seamless Coordination**: Agents work together through proven workflows
- **📈 Scalable Architecture**: Easy to extend with new specialized agents
- **🎛️ User Control**: Automatic selection with manual override capabilities

## 🤖 Available Agents

### 🎯 Product Agent (`product.md`)
**Auto-activated for**: plan, feature, requirement, PRD, roadmap, user story, epic, acceptance criteria

**Expertise**:
- Product planning and requirements engineering
- User story creation with acceptance criteria
- Roadmap development and release planning
- Feature prioritization and scope definition
- Stakeholder communication and handoffs

**Example Triggers**:
- "Help me plan the user authentication feature"
- "Create user stories for the shopping cart"
- "Define requirements for the admin dashboard"

### 🎨 Design Agent (`design.md`)
**Auto-activated for**: UI, interface, design, visual, component, layout, accessibility, responsive

**Expertise**:
- UI/UX design and visual interfaces
- Component design and design systems
- Accessibility and responsive design
- User experience optimization
- Brand integration and visual consistency

**Example Triggers**:
- "Design a responsive navigation component"
- "Create a design system for our app"
- "Make this interface more accessible"

### 🔍 Code Reviewer Agent (`reviewer.md`)
**Auto-activated for**: review, refactor, optimize, clean, quality, standards, patterns, SOLID

**Expertise**:
- Code quality analysis and improvements
- Architecture and design pattern guidance
- Performance optimization recommendations
- Testing strategy and coverage analysis
- Language-specific best practices

**Example Triggers**:
- "Review this pull request for quality issues"
- "Refactor this code to follow SOLID principles"
- "Optimize this function for better performance"

### 🔒 Security Agent (`security.md`)
**Auto-activated for**: security, auth, permission, encrypt, vulnerability, compliance, audit

**Expertise**:
- Security vulnerability assessment
- Authentication and authorization design
- Compliance and regulatory requirements
- Threat modeling and risk analysis
- Secure coding practices

**Example Triggers**:
- "Review this authentication code for security issues"
- "Implement secure password storage"
- "Audit this API for vulnerabilities"

### 🌿 Git Agent (`git.md`)
**Auto-activated for**: commit, merge, branch, tag, release, changelog, version, repository

**Expertise**:
- Version control best practices
- Commit message standards (Conventional Commits)
- Release management and semantic versioning
- Branching strategies and merge workflows
- Repository maintenance and automation

**Example Triggers**:
- "Help me write a proper commit message"
- "Set up a release workflow"
- "Create a changelog for version 2.0"

### 📋 Project Manager Agent (`pm.md`)
**Auto-activated for**: task, milestone, sprint, backlog, WTS, project, deadline, organize

**Expertise**:
- Work Tracking System (WTS) management
- Task coordination and progress tracking
- Session management and handovers
- Project planning and milestone tracking
- Quality gates and process adherence

**Example Triggers**:
- "Break down this feature into tasks"
- "Track progress on the current sprint"
- "Set up the WTS for this project"

### 🚀 DevOps Agent (`devops.md`)
**Auto-activated for**: deploy, container, kubernetes, infrastructure, CI/CD, production, build

**Expertise**:
- Infrastructure as Code (Terraform, CloudFormation)
- Container orchestration (Kubernetes, Docker)
- CI/CD pipeline design and optimization
- Monitoring and observability setup
- Cloud-native architecture patterns

**Example Triggers**:
- "Set up CI/CD pipeline for this project"
- "Deploy this app to Kubernetes"
- "Create Terraform infrastructure"

### 📚 Documentation Agent (`docs.md`)
**Auto-activated for**: document, README, guide, API docs, knowledge, explain, write

**Expertise**:
- Technical writing and documentation
- API documentation (OpenAPI/Swagger)
- Knowledge transfer and onboarding
- Troubleshooting guides and runbooks
- Information architecture and content strategy

**Example Triggers**:
- "Write API documentation for this endpoint"
- "Create a troubleshooting guide"
- "Document the deployment process"

## 🚀 Quick Start

### Prerequisites
- OpenCode CLI installed and configured
- Access to this agent system


### Basic Usage

The system works automatically! Just describe your task naturally:

```bash
# Automatic agent selection
opencode "Review this authentication code for security issues"
# → Activates Security Agent

opencode "Help me plan the user dashboard feature"
# → Activates Product Agent

opencode "Design a responsive card component"
# → Activates Design Agent
```

## 🎮 Usage Patterns

### Single Agent Tasks

Simple requests automatically select the most appropriate agent:

```
"Optimize this database query" → Code Reviewer Agent
"Set up monitoring for production" → DevOps Agent  
"Write documentation for this API" → Documentation Agent
"Create a git workflow for the team" → Git Agent
```

### Multi-Agent Workflows

Complex features automatically coordinate multiple agents:

```
"Implement user authentication system"
↓
1. Product Agent: Define requirements and user stories
2. Design Agent: Create login/signup UI mockups
3. Security Agent: Design secure authentication flow
4. Code Reviewer: Review implementation quality
5. DevOps Agent: Set up secure deployment
6. Git Agent: Plan release strategy
7. Documentation Agent: Create user guides
```

### Manual Agent Selection

Override automatic selection when needed:

```
"Use security agent: review this payment processing code"
"Switch to design agent for the UI components"
"Let the devops agent handle this deployment issue"
```

## 🔧 Advanced Features

### Agent Transparency

The system always tells you which agent is handling your request:

```
✅ High Confidence: "Using **reviewer agent** to analyze code quality..."
⚠️  Medium Confidence: "This looks like a design task - using **design agent**..."
🔄 Multi-Agent: "I'll use **product agent** for planning, then **design agent** for UI..."
🌐 Fallback: "Using general engineering knowledge for this cross-domain task..."
```

### Work Tracking System (WTS) Integration

All agents coordinate through the Project Manager Agent's WTS:

- **Task Creation**: Agents create and assign tasks automatically
- **Progress Tracking**: Real-time status updates across agents
- **Handoffs**: Seamless transitions between agent specializations
- **Quality Gates**: Automated validation checkpoints
- **Session Management**: Continuous context across conversations

### Quality Gates Integration

Agents enforce quality standards at every step:

```
Product Agent → Clear requirements before development starts
Design Agent → UI specifications before implementation begins  
Code Reviewer → Quality standards during development
Security Agent → Security review before deployment
DevOps Agent → Deployment readiness validation
Git Agent → Release management and versioning
Documentation Agent → Documentation completeness check
```

## 📁 File Structure

```
~/.config/opencode/
├── OPENCODE.md              # Master documentation (this file)
└── agents/
    ├── product.md           # Product planning & requirements
    ├── design.md            # UI/UX design & visual interfaces
    ├── reviewer.md          # Code review & quality standards
    ├── security.md          # Security review & compliance  
    ├── git.md              # Version control & release management
    ├── pm.md               # Project management & WTS
    ├── devops.md           # Infrastructure & deployment
    └── docs.md             # Documentation & knowledge transfer
```

## 🎛️ Configuration

### Agent Selection Sensitivity

The system uses weighted scoring for agent selection:

- **High Weight**: Direct domain keywords
- **Medium Weight**: Action verbs and context clues
- **Low Weight**: File types and repository structure

### Override Commands

Force specific agent selection:

```
"Use [agent-name] agent: [your request]"
"Switch to [agent-name] agent"
"Let the [agent-name] agent handle this"
```

Valid agent names: `product`, `design`, `reviewer`, `security`, `git`, `pm`, `devops`, `docs`

## 🔍 Troubleshooting

### Wrong Agent Selected

**Problem**: The system selected an inappropriate agent for your task.

**Solutions**:
1. Use explicit agent selection: `"Use design agent: create a user interface"`
2. Add more specific keywords: `"Help me refactor this code for better performance"`
3. Provide more context: `"I'm working on the UI and need to design a responsive layout"`

### Agent Not Responding

**Problem**: Agent seems to lack domain knowledge.

**Solutions**:
1. Verify agent files are in the correct location: `~/.config/opencode/agents/`
2. Check file permissions: `ls -la ~/.config/opencode/agents/`
3. Try explicit agent selection to test specific agents

### Multi-Agent Coordination Issues

**Problem**: Agents aren't working together effectively.

**Solutions**:
1. Use the PM agent to set up proper WTS structure
2. Break complex tasks into smaller, agent-specific requests
3. Use explicit handoffs: `"Now use the design agent to create the UI"`

## 🚀 Best Practices

### Request Formulation

**Good Examples**:
```
✅ "Review this authentication code for security vulnerabilities"
✅ "Design a responsive navigation component with accessibility features"  
✅ "Set up CI/CD pipeline with automated testing and deployment"
✅ "Create user stories for the shopping cart feature with acceptance criteria"
```

**Less Effective**:
```
❌ "Help me with this code" (too vague)
❌ "Make this better" (unclear domain)
❌ "Fix this" (no context provided)
```

### Workflow Optimization

1. **Start with Planning**: Use Product Agent for requirements and scope
2. **Design First**: Use Design Agent for UI/UX before implementation
3. **Review Early**: Use Code Reviewer during development, not just at the end
4. **Security Throughout**: Involve Security Agent during design and implementation
5. **Document Continuously**: Use Documentation Agent to maintain current docs

### Team Collaboration

- **Shared Vocabulary**: Use consistent terminology across agent interactions
- **Handoff Documentation**: Let PM Agent manage task transitions
- **Quality Gates**: Respect agent-specific quality checkpoints
- **Knowledge Sharing**: Use Documentation Agent for team knowledge transfer

## 🔮 Extending the System

### Adding New Agents

1. **Create Agent File**: `~/.config/opencode/agents/newagent.md`
2. **Define Triggers**: Specify keywords, verbs, and context indicators
3. **Document Expertise**: Detail the agent's specialized knowledge
4. **Update Index**: Add agent to `OPENCODE.md` documentation
5. **Test Integration**: Verify agent selection and coordination

### Agent Template

```markdown
# [Agent Name] - [Specialization] Specialist

## Agent Triggers
**Auto-activated for**: keyword1, keyword2, keyword3

**Verbs**: verb1, verb2, verb3

**Context Indicators**: context1, context2, context3

---

## Mission
[Agent's role and expertise description]

## [Domain] Standards
[Specific standards and practices]

## [Domain] Best Practices
[Industry best practices and guidelines]

## [Domain] Process
[Step-by-step processes and workflows]
```

## 📊 Performance Metrics

### Agent Selection Accuracy
- **Target**: >90% appropriate agent selection
- **Measurement**: User satisfaction with automatic selection
- **Improvement**: Refine trigger patterns based on usage data

### Task Completion Efficiency  
- **Target**: Faster task completion with specialized agents
- **Measurement**: Time from request to satisfactory solution
- **Improvement**: Optimize agent knowledge and coordination

### Cross-Agent Coordination
- **Target**: Seamless handoffs between agents
- **Measurement**: User experience with multi-agent workflows
- **Improvement**: Enhance WTS integration and handoff protocols

## 🤝 Contributing

### Feedback and Improvements

1. **Agent Performance**: Report cases where wrong agent was selected
2. **Knowledge Gaps**: Identify missing expertise in agent domains
3. **Workflow Issues**: Report coordination problems between agents
4. **New Agent Ideas**: Suggest additional specializations needed

### Agent Knowledge Updates

1. **Keep Current**: Update agent knowledge with latest best practices
2. **Add Examples**: Include real-world examples and case studies
3. **Refine Triggers**: Improve keyword and context detection
4. **Test Changes**: Validate updates don't break existing functionality

## 📚 Additional Resources

### Related Documentation
- [Work Tracking System (WTS) Guide](./agents/pm.md#work-tracking-system-wts)
- [Agent Coordination Protocols](./agents/pm.md#inter-agent-communication)  
- [Quality Gates Documentation](./agents/pm.md#quality-gates)

### External References
- [Conventional Commits](https://www.conventionalcommits.org/) (Git Agent)
- [Semantic Versioning](https://semver.org/) (Git Agent)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) (Security Agent)
- [12-Factor App](https://12factor.net/) (DevOps Agent)

## 📝 Changelog

### Version 1.0.0 - 2024-08-16
#### Added
- Initial agent system with 8 specialized agents
- Automated agent selection based on context analysis
- Work Tracking System (WTS) integration
- Multi-agent coordination workflows
- Comprehensive documentation and setup guides

#### Features
- Product planning and requirements engineering
- UI/UX design and visual interface guidance  
- Code quality review and optimization
- Security assessment and compliance
- Version control and release management
- Project management and task coordination
- Infrastructure and deployment automation
- Technical documentation and knowledge transfer

---

**Ready to revolutionize your engineering workflow with intelligent agent specialization!** 🚀

For questions, issues, or suggestions, leverage the PM Agent to track and coordinate improvements to this system.
