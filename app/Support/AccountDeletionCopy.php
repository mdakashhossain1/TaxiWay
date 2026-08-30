<?php

namespace App\Support;

/**
 * All user-facing strings for the public account-deletion page and its
 * validation/error messages, in the 3 locales the taxiway app already
 * ships translations for. Kept separate from the general EmailTemplate
 * system (which covers the *emails*) because this page's copy is fixed
 * chrome, not admin-editable content.
 */
class AccountDeletionCopy
{
    /** Canonical English labels stored in the DB regardless of the UI language the customer picked. */
    private const CANONICAL_REASONS = [
        'not_using' => 'I no longer use this app',
        'found_alternative' => 'I found a better alternative',
        'hard_to_use' => 'The app is difficult to use',
        'pricing' => 'Fares/pricing are too high',
        'bad_experience' => 'I had a bad experience with a driver or ride',
        'privacy' => 'Privacy or data concerns',
    ];

    private const STRINGS = [
        'en' => [
            'meta_title' => 'Delete Your Account',
            'title' => 'Delete Your Account',
            'subtitle' => 'This permanently removes your :app account. No OTP is needed — just confirm the details below.',
            'warning_heading' => 'Deleting your account will permanently erase:',
            'warning_item_1' => 'Your profile and saved details',
            'warning_item_2' => 'Your entire ride and bulk-booking history',
            'warning_item_3' => "Reviews you've written and support tickets you've raised",
            'phone_label' => 'Phone Number',
            'phone_placeholder' => '10-digit mobile number',
            'email_label' => 'Email Address',
            'email_placeholder' => 'you@example.com',
            'reason_label' => 'Reason for leaving',
            'reason_options' => [
                'not_using' => 'I no longer use this app',
                'found_alternative' => 'I found a better alternative',
                'hard_to_use' => 'The app is difficult to use',
                'pricing' => 'Fares/pricing are too high',
                'bad_experience' => 'I had a bad experience with a driver or ride',
                'privacy' => 'Privacy or data concerns',
                'other' => 'Other (please specify)',
            ],
            'reason_placeholder' => "Tell us more...",
            'delete_button' => 'Delete My Account',
            'fine_print' => 'This action is immediate and cannot be undone.',
            'confirm_prompt' => 'This will permanently delete your account and all your data. This cannot be undone. Continue?',
            'success_heading' => 'Your account has been deleted',
            'success_body' => 'Your profile, ride history, saved addresses, and reviews have all been permanently removed from our systems. A confirmation email is on its way to the address you provided.',
            'pending_heading' => 'Check your email to confirm',
            'pending_body' => "Since this account doesn't have an email on file, we've sent a confirmation link to the address you entered. Your account won't be deleted until you click that link. The link expires in 24 hours.",
            'error_no_account' => 'No account was found with that phone number.',
            'error_email_mismatch' => "That email doesn't match the one on this account.",
            'error_active_booking' => 'You have a ride in progress. Please complete or cancel it before deleting your account.',
            'error_active_booking_confirm' => 'You now have a ride in progress. Please complete or cancel it before confirming account deletion.',
            'validation_phone_required' => 'Please enter your phone number.',
            'validation_phone_digits' => 'Phone number must be exactly 10 digits.',
            'validation_email_required' => 'Please enter your email address.',
            'validation_email_invalid' => 'Please enter a valid email address.',
            'validation_reason_option_required' => 'Please select a reason.',
            'validation_reason_required' => 'Please tell us why you\'re deleting your account.',
            'validation_reason_min' => 'Please provide a bit more detail (at least 5 characters).',
        ],
        'hi' => [
            'meta_title' => 'अपना खाता हटाएं',
            'title' => 'अपना खाता हटाएं',
            'subtitle' => 'यह आपका :app खाता स्थायी रूप से हटा देगा। किसी OTP की आवश्यकता नहीं है — बस नीचे विवरण की पुष्टि करें।',
            'warning_heading' => 'खाता हटाने पर यह स्थायी रूप से मिट जाएगा:',
            'warning_item_1' => 'आपकी प्रोफ़ाइल और सहेजे गए विवरण',
            'warning_item_2' => 'आपका पूरा राइड और बल्क-बुकिंग इतिहास',
            'warning_item_3' => 'आपकी लिखी समीक्षाएं और उठाए गए सहायता टिकट',
            'phone_label' => 'फ़ोन नंबर',
            'phone_placeholder' => '10 अंकों का मोबाइल नंबर',
            'email_label' => 'ईमेल पता',
            'email_placeholder' => 'you@example.com',
            'reason_label' => 'खाता हटाने का कारण',
            'reason_options' => [
                'not_using' => 'मैं अब यह ऐप इस्तेमाल नहीं करता/करती',
                'found_alternative' => 'मुझे एक बेहतर विकल्प मिल गया',
                'hard_to_use' => 'ऐप इस्तेमाल करना मुश्किल है',
                'pricing' => 'किराया/मूल्य बहुत अधिक है',
                'bad_experience' => 'ड्राइवर या राइड के साथ बुरा अनुभव हुआ',
                'privacy' => 'गोपनीयता या डेटा संबंधी चिंता',
                'other' => 'अन्य (कृपया बताएं)',
            ],
            'reason_placeholder' => 'अधिक बताएं...',
            'delete_button' => 'मेरा खाता हटाएं',
            'fine_print' => 'यह कार्रवाई तुरंत होगी और इसे पूर्ववत नहीं किया जा सकता।',
            'confirm_prompt' => 'यह आपके खाते और आपके सभी डेटा को स्थायी रूप से हटा देगा। इसे पूर्ववत नहीं किया जा सकता। जारी रखें?',
            'success_heading' => 'आपका खाता हटा दिया गया है',
            'success_body' => 'आपकी प्रोफ़ाइल, राइड इतिहास, सहेजे गए पते और समीक्षाएं हमारे सिस्टम से स्थायी रूप से हटा दी गई हैं। आपके द्वारा दिए गए पते पर एक पुष्टिकरण ईमेल भेजा जा रहा है।',
            'pending_heading' => 'पुष्टि के लिए अपना ईमेल जांचें',
            'pending_body' => 'चूंकि इस खाते में कोई ईमेल दर्ज नहीं है, इसलिए हमने आपके द्वारा दर्ज किए गए पते पर एक पुष्टिकरण लिंक भेजा है। जब तक आप उस लिंक पर क्लिक नहीं करेंगे, आपका खाता हटाया नहीं जाएगा। यह लिंक 24 घंटे में समाप्त हो जाएगा।',
            'error_no_account' => 'उस फ़ोन नंबर से कोई खाता नहीं मिला।',
            'error_email_mismatch' => 'यह ईमेल इस खाते के ईमेल से मेल नहीं खाता।',
            'error_active_booking' => 'आपकी एक राइड चल रही है। खाता हटाने से पहले कृपया उसे पूरा करें या रद्द करें।',
            'error_active_booking_confirm' => 'अब आपकी एक राइड चल रही है। पुष्टि करने से पहले कृपया उसे पूरा करें या रद्द करें।',
            'validation_phone_required' => 'कृपया अपना फ़ोन नंबर दर्ज करें।',
            'validation_phone_digits' => 'फ़ोन नंबर बिल्कुल 10 अंकों का होना चाहिए।',
            'validation_email_required' => 'कृपया अपना ईमेल पता दर्ज करें।',
            'validation_email_invalid' => 'कृपया एक मान्य ईमेल पता दर्ज करें।',
            'validation_reason_option_required' => 'कृपया एक कारण चुनें।',
            'validation_reason_required' => 'कृपया बताएं कि आप अपना खाता क्यों हटा रहे हैं।',
            'validation_reason_min' => 'कृपया थोड़ा और विवरण दें (कम से कम 5 अक्षर)।',
        ],
        'bn' => [
            'meta_title' => 'আপনার অ্যাকাউন্ট মুছুন',
            'title' => 'আপনার অ্যাকাউন্ট মুছুন',
            'subtitle' => 'এটি আপনার :app অ্যাকাউন্ট স্থায়ীভাবে মুছে ফেলবে। কোনো OTP প্রয়োজন নেই — শুধু নিচের বিবরণ নিশ্চিত করুন।',
            'warning_heading' => 'অ্যাকাউন্ট মুছে ফেললে যা স্থায়ীভাবে মুছে যাবে:',
            'warning_item_1' => 'আপনার প্রোফাইল এবং সংরক্ষিত তথ্য',
            'warning_item_2' => 'আপনার সম্পূর্ণ রাইড এবং বাল্ক-বুকিং ইতিহাস',
            'warning_item_3' => 'আপনার লেখা রিভিউ এবং তোলা সাপোর্ট টিকিট',
            'phone_label' => 'ফোন নম্বর',
            'phone_placeholder' => '১০-সংখ্যার মোবাইল নম্বর',
            'email_label' => 'ইমেইল ঠিকানা',
            'email_placeholder' => 'you@example.com',
            'reason_label' => 'অ্যাকাউন্ট মুছার কারণ',
            'reason_options' => [
                'not_using' => 'আমি আর এই অ্যাপ ব্যবহার করি না',
                'found_alternative' => 'আমি একটি ভালো বিকল্প খুঁজে পেয়েছি',
                'hard_to_use' => 'অ্যাপটি ব্যবহার করা কঠিন',
                'pricing' => 'ভাড়া/মূল্য অনেক বেশি',
                'bad_experience' => 'ড্রাইভার বা রাইডের সাথে খারাপ অভিজ্ঞতা হয়েছে',
                'privacy' => 'গোপনীয়তা বা ডেটা সংক্রান্ত উদ্বেগ',
                'other' => 'অন্যান্য (অনুগ্রহ করে বিস্তারিত লিখুন)',
            ],
            'reason_placeholder' => 'আরও বিস্তারিত লিখুন...',
            'delete_button' => 'আমার অ্যাকাউন্ট মুছুন',
            'fine_print' => 'এই কাজটি সঙ্গে সঙ্গে ঘটবে এবং এটি ফিরিয়ে নেওয়া যাবে না।',
            'confirm_prompt' => 'এটি আপনার অ্যাকাউন্ট এবং সমস্ত ডেটা স্থায়ীভাবে মুছে ফেলবে। এটি ফিরিয়ে নেওয়া যাবে না। চালিয়ে যাবেন?',
            'success_heading' => 'আপনার অ্যাকাউন্ট মুছে ফেলা হয়েছে',
            'success_body' => 'আপনার প্রোফাইল, রাইড ইতিহাস, সংরক্ষিত ঠিকানা এবং রিভিউ আমাদের সিস্টেম থেকে স্থায়ীভাবে মুছে ফেলা হয়েছে। আপনার দেওয়া ঠিকানায় একটি নিশ্চিতকরণ ইমেইল পাঠানো হচ্ছে।',
            'pending_heading' => 'নিশ্চিত করতে আপনার ইমেইল দেখুন',
            'pending_body' => 'যেহেতু এই অ্যাকাউন্টে কোনো ইমেইল যুক্ত নেই, তাই আপনি যে ঠিকানা দিয়েছেন সেখানে একটি নিশ্চিতকরণ লিংক পাঠানো হয়েছে। আপনি সেই লিংকে ক্লিক না করা পর্যন্ত আপনার অ্যাকাউন্ট মুছে যাবে না। লিংকটির মেয়াদ ২৪ ঘণ্টা।',
            'error_no_account' => 'সেই ফোন নম্বর দিয়ে কোনো অ্যাকাউন্ট পাওয়া যায়নি।',
            'error_email_mismatch' => 'এই ইমেইলটি এই অ্যাকাউন্টের ইমেইলের সাথে মিলছে না।',
            'error_active_booking' => 'আপনার একটি রাইড চলমান রয়েছে। অ্যাকাউন্ট মুছার আগে অনুগ্রহ করে সেটি সম্পন্ন বা বাতিল করুন।',
            'error_active_booking_confirm' => 'এখন আপনার একটি রাইড চলমান রয়েছে। নিশ্চিত করার আগে অনুগ্রহ করে সেটি সম্পন্ন বা বাতিল করুন।',
            'validation_phone_required' => 'অনুগ্রহ করে আপনার ফোন নম্বর দিন।',
            'validation_phone_digits' => 'ফোন নম্বর অবশ্যই ১০ সংখ্যার হতে হবে।',
            'validation_email_required' => 'অনুগ্রহ করে আপনার ইমেইল ঠিকানা দিন।',
            'validation_email_invalid' => 'অনুগ্রহ করে একটি বৈধ ইমেইল ঠিকানা দিন।',
            'validation_reason_option_required' => 'অনুগ্রহ করে একটি কারণ নির্বাচন করুন।',
            'validation_reason_required' => 'আপনি কেন আপনার অ্যাকাউন্ট মুছছেন তা অনুগ্রহ করে জানান।',
            'validation_reason_min' => 'অনুগ্রহ করে আরেকটু বিস্তারিত লিখুন (কমপক্ষে ৫ অক্ষর)।',
        ],
    ];

    /** Picks a supported locale from an explicit request value, falling back to null if unrecognized. */
    public static function normalize(?string $requested): ?string
    {
        return ($requested && array_key_exists($requested, Locale::SUPPORTED)) ? $requested : null;
    }

    public static function text(string $locale): array
    {
        return self::STRINGS[$locale] ?? self::STRINGS['en'];
    }

    /** All selectable reason keys except 'other', which is handled separately since it has free text. */
    public static function reasonOptionKeys(): array
    {
        return array_keys(self::CANONICAL_REASONS);
    }

    /** The English label to store in the DB for a predefined reason key, regardless of UI language. */
    public static function canonicalReason(string $key): ?string
    {
        return self::CANONICAL_REASONS[$key] ?? null;
    }
}
