<div class="app-sidebar sidebar-shadow <?php echo $accountSidebar[0]['theme']; ?>">
    <div class="app-header__logo">
        <img src="logo/main.png" class="logo-src" />
        <div class="header__pane ml-auto">
            <div>
                <button type="button" class="hamburger close-sidebar-btn hamburger--elastic"
                    data-class="closed-sidebar">
                    <span class="hamburger-box">
                        <span class="hamburger-inner"></span>
                    </span>
                </button>
            </div>
        </div>
    </div>
    <div class="app-header__mobile-menu">
        <div>
            <button type="button" class="hamburger hamburger--elastic mobile-toggle-nav">
                <span class="hamburger-box">
                    <span class="hamburger-inner"></span>
                </span>
            </button>
        </div>
    </div>
    <div class="app-header__menu">
        <span>
            <button type="button" class="btn-icon btn-icon-only btn btn-primary btn-sm mobile-toggle-header-nav">
                <span class="btn-icon-wrapper">
                    <i class="fa fa-ellipsis-v fa-w-6"></i>
                </span>
            </button>
        </span>
    </div>
    <div class="scrollbar-sidebar">
        <div class="app-sidebar__inner">
            <ul class="vertical-nav-menu">
                <li class="app-sidebar__heading">Main</li>
                <li>
                    <a href="?view=HOME" class="mm-active" style="text-decoration:none;">
                        <i class="fa fa-tachometer"></i>
                        Dashboard
                    </a>
                </li>
                <li>
                    <a href="?view=PATIENT"  style="text-decoration:none;">
                        <i class="fa fa-child"></i>
                        Patient Management
                    </a>
                </li>
                <li>
                    <a href="?view=SCHEDULING"  style="text-decoration:none;">
                        <i class="fa fa-calendar"></i>
                        Appointment Scheduling
                    </a>
                </li>
                <li>
                    <a href="?view=SERVICE"  style="text-decoration:none;">
                        <i class="fa fa-suitcase"></i>
                        Services
                    </a>
                </li>
                <li>
                    <a href="?view=REPORTS"  style="text-decoration:none;">
                        <i class="fa fa-line-chart"></i>
                        Reports
                    </a>
                </li>
                <li>
                    <a href="?view=INQUIRY"  style="text-decoration:none;">
                        <i class="fa fa-info-circle"></i>
                        Inquiry
                    </a>
                </li>
                <li>
                    <a href="?view=ANNOUNCEMENT"  style="text-decoration:none;">
                        <i class="fa fa-bullhorn"></i>
                        Announcement
                    </a>
                </li>
            </ul>
            <ul class="vertical-nav-menu">
                <li class="app-sidebar__heading">Configuration</li>
                <li>
                    <a href="?view=ACCOUNTS" style="text-decoration:none;">
                        <i class="fa fa-group"></i>
                        Staff
                    </a>
                </li>
                <li>
                    <a href="?view=BILLING" style="text-decoration:none;">
                        <i class="fa fa-institution"></i>
                        Account Billing
                    </a>
                </li>
                <li>
                    <a href="?view=INTEGRATION" style="text-decoration:none;">
                        <i class="fa fa-money"></i>
                        Payment Integration
                    </a>
                </li>
            </ul>
            <ul class="vertical-nav-menu">
                <li class="app-sidebar__heading">Support</li>
                <li>
                    <a href="?view=SUPPORT" style="text-decoration:none;">
                        <i class="fa fa-commenting"></i>
                        Ticket
                    </a>
                </li>
            </ul>
        </div>
    </div>
</div>