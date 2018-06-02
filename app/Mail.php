<?php
declare(strict_types=1);
namespace App;

use DateTimeImmutable;
use Illuminate\Mail\Mailable;

class Mail extends Mailable
{
    /**
     * @var string
     */
    private $file;

    public function __construct(string $file)
    {
        $this->file = $file;
    }

    public function build()
    {
        $now = new DateTimeImmutable();
        $this->to(env('EMAIL'));
        $this->subject('Glagol DSL: Latest thesis built');
        $this->attach($this->file, [
            'as' => "msc_thesis_{$now->format('Y_m_d')}.pdf",
            'mime' => 'application/pdf',
        ]);

        return $this->view('mail');
    }
}