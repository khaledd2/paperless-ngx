import uuid

from django.conf import settings
from django.contrib.auth.models import User
from django.test import TestCase
from django.test import override_settings
from django.urls import resolve
from django.urls import reverse
from rest_framework import status

from paperless.models import ApplicationConfiguration


class TestApiAuthViews(TestCase):
    def test_api_auth_login_uses_allauth_login_view(self):
        response = self.client.get(reverse("rest_framework:login"))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTemplateUsed(response, "account/login.html")

    def test_api_auth_login_uses_same_view_as_account_login(self):
        api_match = resolve("/api/auth/login/")
        account_match = resolve("/accounts/login/")

        self.assertIs(api_match.func.view_class, account_match.func.view_class)

    @override_settings(DISABLE_REGULAR_LOGIN=True)
    def test_api_auth_login_respects_disable_regular_login(self):
        username = f"testuser-{uuid.uuid4().hex}"
        User.objects.create_user(
            username=username,
            password="testpassword",
        )

        response = self.client.post(
            reverse("rest_framework:login"),
            data={
                "login": username,
                "password": "testpassword",
                "next": "/api/documents/",
            },
        )

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTemplateUsed(response, "account/login.html")
        self.assertContains(response, "Regular login is disabled")
        self.assertNotIn("_auth_user_id", self.client.session)

    def test_api_auth_logout_uses_named_route(self):
        self.assertEqual(reverse("rest_framework:login"), "/api/auth/login/")
        self.assertEqual(reverse("rest_framework:logout"), "/api/auth/logout/")

    def test_auth_page_direction_follows_language(self):
        """
        GIVEN:
            - The login page rendered in a left-to-right and a right-to-left language
        WHEN:
            - The page is loaded
        THEN:
            - The document direction and the Bootstrap build match the language
        """
        for language, direction, stylesheet in [
            ("en-us", "ltr", "bootstrap.min.css"),
            ("ar-ar", "rtl", "bootstrap.rtl.min.css"),
        ]:
            self.client.cookies.load({settings.LANGUAGE_COOKIE_NAME: language})
            response = self.client.get(reverse("rest_framework:login"))

            self.assertEqual(response.status_code, status.HTTP_200_OK)
            self.assertContains(response, f'lang="{language}"')
            self.assertContains(response, f'dir="{direction}"')
            self.assertContains(response, stylesheet)

            other_stylesheet = (
                "bootstrap.min.css"
                if stylesheet == "bootstrap.rtl.min.css"
                else "bootstrap.rtl.min.css"
            )
            self.assertNotContains(response, other_stylesheet)

    def test_auth_page_uses_shift_logo(self):
        """
        GIVEN:
            - The auth page with no custom app logo or title configured
        WHEN:
            - The page is loaded in a left-to-right and a right-to-left language
        THEN:
            - The Shift brand mark and its title are shown, in the UI language,
              instead of the Paperless-ngx logo
        """
        for language, title in [
            ("en-us", "Shift - Cloud Archiving"),
            ("ar-ar", "شفت - للارشفة السحابية"),
        ]:
            self.client.cookies.load({settings.LANGUAGE_COOKIE_NAME: language})
            response = self.client.get(reverse("rest_framework:login"))

            self.assertEqual(response.status_code, status.HTTP_200_OK)
            self.assertContains(response, "shift-logo.png")
            self.assertContains(response, 'alt="Shift"')
            self.assertContains(response, title)
            # the Paperless-ngx wordmark viewBox is no longer rendered here
            self.assertNotContains(response, "2670 860")

    def test_auth_page_uses_shift_logo_with_app_title(self):
        """
        GIVEN:
            - An app title configured through the application settings
        WHEN:
            - The auth page is loaded
        THEN:
            - The Shift brand mark is shown instead of the Paperless-ngx leaf
        """
        ApplicationConfiguration(app_title="Shift - Cloud Archiving").save()

        response = self.client.get(reverse("rest_framework:login"))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertContains(response, "shift-logo.png")
        self.assertContains(response, "Shift - Cloud Archiving")
        # the Paperless-ngx leaf path is no longer rendered here
        self.assertNotContains(response, "341,949.1")
