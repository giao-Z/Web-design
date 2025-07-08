package com.newsmanagement.controller;

import com.newsmanagement.entity.User;
import com.newsmanagement.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.validation.Valid;
import java.util.Optional;

/**
 * 用户控制器
 */
@Controller
public class UserController {

    @Autowired
    private UserService userService;

    /**
     * 显示登录页面
     */
    @GetMapping("/login")
    public String showLoginForm(Model model, @RequestParam(value = "error", required = false) String error) {
        if (error != null) {
            model.addAttribute("error", "用户名或密码错误");
        }
        return "auth/login";
    }

    /**
     * 显示注册页面
     */
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    /**
     * 处理用户注册
     */
    @PostMapping("/register")
    public String registerUser(@Valid @ModelAttribute("user") User user,
                              BindingResult result,
                              @RequestParam("confirmPassword") String confirmPassword,
                              Model model,
                              RedirectAttributes redirectAttributes) {
        
        // 验证密码确认
        if (!user.getPassword().equals(confirmPassword)) {
            result.rejectValue("password", "error.user", "密码和确认密码不匹配");
        }

        if (result.hasErrors()) {
            return "auth/register";
        }

        try {
            userService.registerUser(user.getUsername(), user.getPassword(), user.getEmail());
            redirectAttributes.addFlashAttribute("success", "注册成功，请登录");
            return "redirect:/login";
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register";
        }
    }

    /**
     * 显示用户个人资料页面
     */
    @GetMapping("/profile")
    public String showProfile(Model model, Authentication authentication) {
        String username = authentication.getName();
        Optional<User> userOpt = userService.findByUsernameOrEmail(username);
        
        if (userOpt.isPresent()) {
            model.addAttribute("user", userOpt.get());
            return "user/profile";
        }
        
        return "redirect:/login";
    }

    /**
     * 更新用户个人资料
     */
    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam("realName") String realName,
                               @RequestParam("phone") String phone,
                               @RequestParam("email") String email,
                               Authentication authentication,
                               RedirectAttributes redirectAttributes) {
        
        String username = authentication.getName();
        Optional<User> userOpt = userService.findByUsernameOrEmail(username);
        
        if (userOpt.isPresent()) {
            try {
                userService.updateUserProfile(userOpt.get().getId(), realName, phone, email);
                redirectAttributes.addFlashAttribute("success", "个人资料更新成功");
            } catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("error", e.getMessage());
            }
        }
        
        return "redirect:/profile";
    }

    /**
     * 显示修改密码页面
     */
    @GetMapping("/profile/change-password")
    public String showChangePasswordForm() {
        return "user/change-password";
    }

    /**
     * 修改密码
     */
    @PostMapping("/profile/change-password")
    public String changePassword(@RequestParam("oldPassword") String oldPassword,
                                @RequestParam("newPassword") String newPassword,
                                @RequestParam("confirmPassword") String confirmPassword,
                                Authentication authentication,
                                RedirectAttributes redirectAttributes) {
        
        if (!newPassword.equals(confirmPassword)) {
            redirectAttributes.addFlashAttribute("error", "新密码和确认密码不匹配");
            return "redirect:/profile/change-password";
        }

        String username = authentication.getName();
        Optional<User> userOpt = userService.findByUsernameOrEmail(username);
        
        if (userOpt.isPresent()) {
            try {
                userService.changePassword(userOpt.get().getId(), oldPassword, newPassword);
                redirectAttributes.addFlashAttribute("success", "密码修改成功");
                return "redirect:/profile";
            } catch (RuntimeException e) {
                redirectAttributes.addFlashAttribute("error", e.getMessage());
                return "redirect:/profile/change-password";
            }
        }
        
        return "redirect:/login";
    }

    /**
     * 管理员用户管理页面
     */
    @GetMapping("/admin/users")
    public String manageUsers(Model model) {
        model.addAttribute("users", userService.getAllUsers());
        return "admin/users";
    }

    /**
     * 切换用户状态（启用/禁用）
     */
    @PostMapping("/admin/users/{id}/toggle")
    public String toggleUserStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            userService.toggleUserStatus(id);
            redirectAttributes.addFlashAttribute("success", "用户状态已更新");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "操作失败: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    /**
     * 设置用户角色
     */
    @PostMapping("/admin/users/{id}/role")
    public String setUserRole(@PathVariable Long id, 
                             @RequestParam("role") User.Role role,
                             RedirectAttributes redirectAttributes) {
        try {
            userService.setUserRole(id, role);
            redirectAttributes.addFlashAttribute("success", "用户角色已更新");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "操作失败: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    /**
     * 获取当前登录用户
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            return userService.findByUsernameOrEmail(username).orElse(null);
        }
        return null;
    }
}

