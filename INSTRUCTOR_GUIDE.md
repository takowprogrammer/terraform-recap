# Terraform Learning Session - Session Guide

## 🎓 Instructor Notes

This guide is for instructors leading the 2-3 hour Terraform workshop.

### Session Timeline

**Total Duration:** 2.5 hours

#### Introduction (10 minutes)
- Welcome and introductions
- Overview of Infrastructure as Code
- What we'll build today
- Prerequisites check

#### Module 1: Basics (45 minutes)
- **Theory (10 min):** IaC concepts, Terraform basics
- **Demo (15 min):** Live coding the first example
- **Hands-on (15 min):** Students complete exercises
- **Review (5 min):** Discuss solutions

#### Break (5 minutes)

#### Module 2: Intermediate (60 minutes)
- **Theory (10 min):** State management, modules
- **Demo (20 min):** Docker provider walkthrough
- **Hands-on (25 min):** Students build Docker stack
- **Review (5 min):** Discuss challenges

#### Break (5 minutes)

#### Module 3: Advanced (45 minutes)
- **Theory (10 min):** Workspaces, best practices
- **Demo (15 min):** Multi-environment deployment
- **Hands-on (15 min):** Students experiment with workspaces
- **Wrap-up (5 min):** Q&A and next steps

### Teaching Tips

1. **Start Simple:** Don't overwhelm with all features at once
2. **Live Demo:** Code alongside students in Module 1
3. **Encourage Experimentation:** Breaking things is learning
4. **Common Mistakes:** Be ready to help with:
   - Forgetting `terraform init`
   - Docker not running
   - Port conflicts
   - Syntax errors

### Key Concepts to Emphasize

- **Declarative vs Imperative:** Terraform describes desired state
- **Idempotency:** Running apply multiple times is safe
- **State is Critical:** Never manually edit state files
- **Plan Before Apply:** Always preview changes

### Preparation Checklist

- [ ] Verify Terraform installed on all machines
- [ ] Verify Docker Desktop installed and running
- [ ] Test all examples beforehand
- [ ] Prepare backup solutions for common issues
- [ ] Have Terraform documentation ready

### Troubleshooting Quick Reference

**Issue:** "Provider not found"
**Solution:** Run `terraform init`

**Issue:** "Docker daemon not running"
**Solution:** Start Docker Desktop

**Issue:** "Port already in use"
**Solution:** `docker ps` and stop conflicting containers

**Issue:** "State locked"
**Solution:** Wait or use `terraform force-unlock`

### Extension Activities

If students finish early:
1. Modify exercises to add more complexity
2. Explore Terraform Registry for other providers
3. Research cloud provider free tiers
4. Discuss CI/CD integration

### Assessment Questions

1. What's the difference between `plan` and `apply`?
2. When would you use `count` vs `for_each`?
3. Why is state management important?
4. How do workspaces help with multi-environment setups?

---

Good luck with your session! 🚀
