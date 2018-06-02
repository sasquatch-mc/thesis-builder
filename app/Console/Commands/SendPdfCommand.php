<?php
declare(strict_types=1);
namespace App\Console\Commands;

use App\Mail;
use Illuminate\Console\Command;

class SendPdfCommand extends Command
{
    protected $signature = 'pdf:send {path}';

    public function handle()
    {
        $filePath = $this->argument('path');
        if (!file_exists($filePath)) {
            $this->error("File '{$filePath}' not found");
            exit(255);
        }

        $mail = new Mail($filePath);
        $mail->send(app('mailer'));
    }
}
